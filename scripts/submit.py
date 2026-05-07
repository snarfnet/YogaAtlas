import hashlib
import os
import sys
import time

import jwt
import requests

KEY_ID = 'WDXGY9WX55'
ISSUER = '2be0734f-943a-4d61-9dc9-5d9045c46fec'
BUNDLE_ID = 'com.tokyonasu.YogaAtlas'
APP_VERSION = '1.3'
BUILD_NUMBER = sys.argv[1]
SCREENSHOT_DIR = 'screenshots/appstore'

SCREENSHOT_GROUPS = [
    ('APP_IPHONE_69', ['iphone_69_1_home.png', 'iphone_69_2_prescription.png', 'iphone_69_3_meditation.png']),
    ('APP_IPHONE_67', ['iphone_67_1_home.png', 'iphone_67_2_prescription.png', 'iphone_67_3_meditation.png']),
    ('APP_IPHONE_65', ['iphone_65_1_home.png', 'iphone_65_2_prescription.png', 'iphone_65_3_meditation.png']),
    ('APP_IPHONE_61', ['iphone_61_1_home.png', 'iphone_61_2_prescription.png', 'iphone_61_3_meditation.png']),
    ('APP_IPHONE_58', ['iphone_58_1_home.png', 'iphone_58_2_prescription.png', 'iphone_58_3_meditation.png']),
    ('APP_IPHONE_55', ['iphone_55_1_home.png', 'iphone_55_2_prescription.png', 'iphone_55_3_meditation.png']),
    ('APP_IPAD_PRO_3GEN_129', ['ipad_129_1_home.png', 'ipad_129_2_prescription.png', 'ipad_129_3_meditation.png']),
    ('APP_IPAD_PRO_2GEN_129', ['ipad_129_1_home.png', 'ipad_129_2_prescription.png', 'ipad_129_3_meditation.png']),
]

WHATS_NEW = {
    'ja': 'ヨガの魅力が伝わるようにデザインを大幅刷新しました。写真付きの画面、読みやすいポーズ解説、悩み別ケア、瞑想、チャクラ画面を改善しています。',
    'en-US': 'Refreshed the yoga experience with richer visuals, clearer pose guidance, symptom care, meditation, chakra content, and updated screenshots.',
}
p8 = open('/tmp/asc_key.p8').read()


def make_token():
    now = int(time.time())
    return jwt.encode(
        {'iss': ISSUER, 'iat': now, 'exp': now + 1200, 'aud': 'appstoreconnect-v1'},
        p8,
        algorithm='ES256',
        headers={'kid': KEY_ID}
    )


def headers():
    return {'Authorization': f'Bearer {make_token()}', 'Content-Type': 'application/json'}


def api(method, path, **kwargs):
    last = None
    for attempt in range(6):
        last = requests.request(
            method,
            f'https://api.appstoreconnect.apple.com/v1{path}',
            headers=headers(),
            timeout=90,
            **kwargs
        )
        if last.status_code not in (401, 500, 502, 503, 504):
            return last
        print(f'API retry {method} {path} attempt {attempt + 1}/6: {last.status_code}')
        time.sleep(15)
    return last


def api_json(method, path, **kwargs):
    r = api(method, path, **kwargs)
    try:
        body = r.json()
    except Exception:
        body = {}
    return r, body


def list_all(path):
    data = []
    next_path = path
    while next_path:
        r, body = api_json('GET', next_path)
        if r.status_code != 200:
            print(f'List failed {next_path}: {r.status_code} {r.text[:500]}')
            sys.exit(1)
        data.extend(body.get('data', []))
        next_url = body.get('links', {}).get('next')
        next_path = next_url.split('/v1', 1)[1] if next_url else None
    return data


def find_app_id():
    print(f'Looking up app by bundle ID: {BUNDLE_ID}')
    r, body = api_json('GET', f'/apps?filter[bundleId]={BUNDLE_ID}')
    if not body.get('data'):
        print(f'App not found for bundle ID {BUNDLE_ID}.')
        sys.exit(1)
    app_id = body['data'][0]['id']
    print(f'App ID: {app_id}')
    return app_id


def find_or_create_version(app_id):
    versions = list_all(f'/apps/{app_id}/appStoreVersions?filter[platform]=IOS&limit=200')
    for version in versions:
        attrs = version.get('attributes', {})
        if attrs.get('versionString') == APP_VERSION:
            print(f'Found version {APP_VERSION}: {version["id"]} state={attrs.get("appStoreState")}')
            return version['id'], attrs.get('appStoreState')

    print(f'Creating new version {APP_VERSION}...')
    r, body = api_json('POST', '/appStoreVersions', json={
        'data': {
            'type': 'appStoreVersions',
            'attributes': {'platform': 'IOS', 'versionString': APP_VERSION},
            'relationships': {'app': {'data': {'type': 'apps', 'id': app_id}}}
        }
    })
    if r.status_code not in (200, 201):
        print(f'Failed to create version: {r.status_code} {r.text[:1000]}')
        sys.exit(1)
    version_id = body['data']['id']
    print(f'Created version {APP_VERSION}: {version_id}')
    return version_id, 'PREPARE_FOR_SUBMISSION'


def version_is_already_submitted(state):
    return state in ('WAITING_FOR_REVIEW', 'IN_REVIEW', 'PENDING_DEVELOPER_RELEASE', 'PENDING_APPLE_RELEASE')


def wait_for_build(app_id):
    print(f'Waiting for build {BUILD_NUMBER} to be processed...')
    for i in range(80):
        r, body = api_json('GET', f'/builds?filter[app]={app_id}&filter[version]={BUILD_NUMBER}&filter[processingState]=VALID&limit=1')
        if body.get('data'):
            build_id = body['data'][0]['id']
            print(f'Build ready: {build_id}')
            return build_id
        print(f'  Waiting... ({i + 1}/80)')
        time.sleep(30)
    print('Build was not processed in time.')
    sys.exit(1)


def set_export_compliance(build_id):
    r = api('PATCH', f'/builds/{build_id}', json={
        'data': {'type': 'builds', 'id': build_id, 'attributes': {'usesNonExemptEncryption': False}}
    })
    print(f'Export compliance: {r.status_code}')


def update_version_localizations(version_id):
    print('Updating release notes...')
    locs = list_all(f'/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=200')
    for loc in locs:
        locale = loc['attributes'].get('locale', 'unknown')
        whats_new = WHATS_NEW.get(locale, WHATS_NEW['en-US'])
        r = api('PATCH', f'/appStoreVersionLocalizations/{loc["id"]}', json={
            'data': {'type': 'appStoreVersionLocalizations', 'id': loc['id'], 'attributes': {'whatsNew': whats_new}}
        })
        print(f'  Release notes {locale}: {r.status_code}')


def delete_existing_screenshots(set_id):
    for screenshot in list_all(f'/appScreenshotSets/{set_id}/appScreenshots?limit=200'):
        r = api('DELETE', f'/appScreenshots/{screenshot["id"]}')
        print(f'      Delete old screenshot {screenshot["id"]}: {r.status_code}')


def upload_one_screenshot(set_id, filepath, filename):
    file_data = open(filepath, 'rb').read()
    filesize = len(file_data)
    checksum = hashlib.md5(file_data).hexdigest()
    r, body = api_json('POST', '/appScreenshots', json={
        'data': {
            'type': 'appScreenshots',
            'attributes': {'fileName': filename, 'fileSize': filesize},
            'relationships': {'appScreenshotSet': {'data': {'type': 'appScreenshotSets', 'id': set_id}}}
        }
    })
    if r.status_code not in (200, 201):
        print(f'      Reserve {filename}: FAILED {r.status_code} {r.text[:500]}')
        return False

    screenshot = body['data']
    screenshot_id = screenshot['id']
    print(f'      Reserved {filename}: {screenshot_id}')
    for op in screenshot['attributes']['uploadOperations']:
        op_headers = {h['name']: h['value'] for h in op['requestHeaders']}
        chunk = file_data[op['offset']:op['offset'] + op['length']]
        pr = requests.put(op['url'], headers=op_headers, data=chunk, timeout=90)
        print(f'        Upload part: {pr.status_code}')
        if pr.status_code not in (200, 201):
            return False

    source_checksum = screenshot['attributes'].get('sourceFileChecksum') or checksum
    for attempt in range(12):
        r = api('PATCH', f'/appScreenshots/{screenshot_id}', json={
            'data': {
                'type': 'appScreenshots',
                'id': screenshot_id,
                'attributes': {'uploaded': True, 'sourceFileChecksum': source_checksum}
            }
        })
        print(f'      Commit {filename} attempt {attempt + 1}/12: {r.status_code}')
        if r.status_code == 200:
            return True
        time.sleep(10)
    print(f'      Commit failed for {filename}: {r.text[:500]}')
    return False


def upload_screenshots(version_id):
    print('Replacing screenshots...')
    locs = list_all(f'/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=200')
    for loc in locs:
        locale = loc['attributes'].get('locale', 'unknown')
        print(f'  Locale: {locale}')
        sets = list_all(f'/appStoreVersionLocalizations/{loc["id"]}/appScreenshotSets?limit=200')
        existing_sets = {s['attributes']['screenshotDisplayType']: s['id'] for s in sets}
        for display_type, filenames in SCREENSHOT_GROUPS:
            if display_type in existing_sets:
                set_id = existing_sets[display_type]
            else:
                r, body = api_json('POST', '/appScreenshotSets', json={
                    'data': {
                        'type': 'appScreenshotSets',
                        'attributes': {'screenshotDisplayType': display_type},
                        'relationships': {'appStoreVersionLocalization': {'data': {'type': 'appStoreVersionLocalizations', 'id': loc['id']}}}
                    }
                })
                if r.status_code not in (200, 201):
                    print(f'    Create set {display_type}: SKIPPED {r.status_code} {r.text[:500]}')
                    continue
                set_id = body['data']['id']
            print(f'    Display: {display_type} set={set_id}')
            delete_existing_screenshots(set_id)
            for filename in filenames:
                filepath = os.path.join(SCREENSHOT_DIR, filename)
                if not os.path.exists(filepath):
                    print(f'      Missing {filepath}')
                    sys.exit(1)
                if not upload_one_screenshot(set_id, filepath, filename):
                    sys.exit(1)


def assign_build(version_id, build_id):
    r = api('PATCH', f'/appStoreVersions/{version_id}/relationships/build', json={'data': {'type': 'builds', 'id': build_id}})
    print(f'Build assigned: {r.status_code}')


def get_submission_items(submission_id):
    r, body = api_json('GET', f'/reviewSubmissions/{submission_id}/items?limit=200')
    return body.get('data', []) if r.status_code == 200 else []


def find_reusable_submission(app_id):
    r, body = api_json('GET', f'/apps/{app_id}/reviewSubmissions?filter[state]=READY_FOR_REVIEW&limit=200')
    if r.status_code != 200:
        return None
    for sub in body.get('data', []):
        items = get_submission_items(sub['id'])
        if not sub.get('attributes', {}).get('submittedDate') and not items:
            return sub['id']
    return None


def submit_for_review(app_id, version_id):
    submission_id = find_reusable_submission(app_id)
    if submission_id:
        print(f'Reusing empty ReviewSubmission: {submission_id}')
    else:
        r, body = api_json('POST', '/reviewSubmissions', json={
            'data': {'type': 'reviewSubmissions', 'relationships': {'app': {'data': {'type': 'apps', 'id': app_id}}}}
        })
        if r.status_code != 201:
            print(f'Create reviewSubmission failed: {r.status_code} {r.text[:2000]}')
            sys.exit(1)
        submission_id = body['data']['id']
        print(f'ReviewSubmission created: {submission_id}')

    item_added = False
    for attempt in range(20):
        r = api('POST', '/reviewSubmissionItems', json={
            'data': {
                'type': 'reviewSubmissionItems',
                'relationships': {
                    'reviewSubmission': {'data': {'type': 'reviewSubmissions', 'id': submission_id}},
                    'appStoreVersion': {'data': {'type': 'appStoreVersions', 'id': version_id}}
                }
            }
        })
        print(f'Add item attempt {attempt + 1}/20: {r.status_code}')
        if r.status_code == 201:
            item_added = True
            break
        time.sleep(30)
    if not item_added:
        print(f'Failed to add item: {r.text[:2000]}')
        sys.exit(1)

    r, body = api_json('PATCH', f'/reviewSubmissions/{submission_id}', json={
        'data': {'type': 'reviewSubmissions', 'id': submission_id, 'attributes': {'submitted': True}}
    })
    if r.status_code == 200:
        print(f'Submitted! State: {body["data"]["attributes"]["state"]}')
    else:
        print(f'Submit failed: {r.status_code} {r.text[:2000]}')
        sys.exit(1)


app_id = find_app_id()
version_id, version_state = find_or_create_version(app_id)
already_submitted = version_is_already_submitted(version_state)
if already_submitted:
    print(f'Version {APP_VERSION} is already submitted ({version_state}). Updating screenshots if App Store Connect allows it.')

build_id = wait_for_build(app_id)
set_export_compliance(build_id)
update_version_localizations(version_id)
upload_screenshots(version_id)
print('Waiting for App Store Connect to finish screenshot processing...')
time.sleep(300)
assign_build(version_id, build_id)
if already_submitted:
    print(f'Version {APP_VERSION} was already submitted. Screenshot refresh finished; no new review submission needed.')
else:
    submit_for_review(app_id, version_id)

