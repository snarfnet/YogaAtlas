import sys
import time

import jwt
import requests

KEY_ID = 'WDXGY9WX55'
ISSUER = '2be0734f-943a-4d61-9dc9-5d9045c46fec'
BUNDLE_ID = 'com.tokyonasu.YogaAtlas'
APP_VERSION = '1.3'

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
        time.sleep(20)
    return last


def api_json(method, path, **kwargs):
    r = api(method, path, **kwargs)
    try:
        return r, r.json()
    except Exception:
        return r, {}


def list_all(path):
    data = []
    next_path = path
    while next_path:
        r, body = api_json('GET', next_path)
        if r.status_code != 200:
            print(f'List failed {next_path}: {r.status_code} {r.text[:800]}')
            sys.exit(1)
        data.extend(body.get('data', []))
        next_url = body.get('links', {}).get('next')
        next_path = next_url.split('/v1', 1)[1] if next_url else None
    return data


def find_app_id():
    r, body = api_json('GET', f'/apps?filter[bundleId]={BUNDLE_ID}')
    if not body.get('data'):
        print(f'App not found for bundle ID {BUNDLE_ID}')
        sys.exit(1)
    return body['data'][0]['id']


def find_version(app_id):
    versions = list_all(f'/apps/{app_id}/appStoreVersions?filter[platform]=IOS&limit=200')
    for version in versions:
        attrs = version.get('attributes', {})
        if attrs.get('versionString') == APP_VERSION:
            print(f'Found version {APP_VERSION}: {version["id"]} state={attrs.get("appStoreState")}')
            return version['id'], attrs.get('appStoreState')
    print(f'Version {APP_VERSION} not found')
    sys.exit(1)


def get_submission_items(submission_id):
    r, body = api_json('GET', f'/reviewSubmissions/{submission_id}/items?limit=200')
    return body.get('data', []) if r.status_code == 200 else []


def find_ready_submission(app_id, version_id):
    submissions = list_all(f'/apps/{app_id}/reviewSubmissions?filter[state]=READY_FOR_REVIEW&limit=200')
    for submission in submissions:
        if submission.get('attributes', {}).get('submittedDate'):
            continue
        items = get_submission_items(submission['id'])
        for item in items:
            relationship = item.get('relationships', {}).get('appStoreVersion', {}).get('data', {})
            if relationship.get('id') == version_id:
                return submission['id'], True
        if not items:
            return submission['id'], False
    return None, False


def create_submission(app_id):
    r, body = api_json('POST', '/reviewSubmissions', json={
        'data': {'type': 'reviewSubmissions', 'relationships': {'app': {'data': {'type': 'apps', 'id': app_id}}}}
    })
    if r.status_code != 201:
        print(f'Create reviewSubmission failed: {r.status_code} {r.text[:1500]}')
        sys.exit(1)
    return body['data']['id']


def ensure_submission(app_id, version_id):
    submission_id, has_item = find_ready_submission(app_id, version_id)
    if submission_id:
        print(f'Reusing ReviewSubmission: {submission_id}')
        return submission_id, has_item
    submission_id = create_submission(app_id)
    print(f'Created ReviewSubmission: {submission_id}')
    return submission_id, False


def add_item_when_ready(submission_id, version_id):
    last_text = ''
    for attempt in range(60):
        r = api('POST', '/reviewSubmissionItems', json={
            'data': {
                'type': 'reviewSubmissionItems',
                'relationships': {
                    'reviewSubmission': {'data': {'type': 'reviewSubmissions', 'id': submission_id}},
                    'appStoreVersion': {'data': {'type': 'appStoreVersions', 'id': version_id}}
                }
            }
        })
        last_text = r.text
        print(f'Add item attempt {attempt + 1}/60: {r.status_code}')
        if r.status_code == 201:
            return True
        time.sleep(120)
    print(f'Failed to add item: {last_text[:2000]}')
    return False


def submit(submission_id):
    r, body = api_json('PATCH', f'/reviewSubmissions/{submission_id}', json={
        'data': {'type': 'reviewSubmissions', 'id': submission_id, 'attributes': {'submitted': True}}
    })
    if r.status_code == 200:
        print(f'Submitted! State: {body["data"]["attributes"]["state"]}')
        return True
    print(f'Submit failed: {r.status_code} {r.text[:2000]}')
    return False


app_id = find_app_id()
version_id, state = find_version(app_id)
if state in ('WAITING_FOR_REVIEW', 'IN_REVIEW'):
    print(f'Version {APP_VERSION} already submitted: {state}')
    sys.exit(0)

submission_id, has_item = ensure_submission(app_id, version_id)
if not has_item and not add_item_when_ready(submission_id, version_id):
    sys.exit(1)
if not submit(submission_id):
    sys.exit(1)
