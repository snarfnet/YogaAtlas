#!/usr/bin/env ruby
# YogaAtlas Xcodeプロジェクト生成スクリプト
# 実行: ruby generate_xcodeproj.rb

require 'xcodeproj'

PROJECT_NAME = 'YogaAtlas'
BUNDLE_ID    = 'com.tokyonasu.YogaAtlas'
DEPLOYMENT   = '16.0'

# プロジェクト作成
project = Xcodeproj::Project.new("#{PROJECT_NAME}.xcodeproj")

# メインターゲット
target = project.new_target(:application, PROJECT_NAME, :ios, DEPLOYMENT)
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = BUNDLE_ID
  config.build_settings['SWIFT_VERSION'] = '5.9'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = DEPLOYMENT
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1'  # iPhone only
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['INFOPLIST_FILE'] = "#{PROJECT_NAME}/Info.plist"
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UIApplicationSceneManifest_Generation'] = 'NO'
  config.build_settings['INFOPLIST_KEY_UILaunchScreen_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone'] = 'UIInterfaceOrientationPortrait'
  config.build_settings['INFOPLIST_KEY_CFBundleDisplayName'] = 'ヨガ・アトラス'
  config.build_settings['INFOPLIST_KEY_LSApplicationCategoryType'] = 'public.app-category.health-fitness'
end

# メイングループ
main_group = project.main_group.new_group(PROJECT_NAME, PROJECT_NAME)

# ソースファイルを追加するヘルパー
def add_sources(group, dir, target, project)
  Dir.glob("#{dir}/**/*.swift").sort.each do |path|
    relative = path.sub("#{dir}/", '')
    parts = relative.split('/')
    current_group = group
    parts[0..-2].each do |part|
      current_group = current_group[part] || current_group.new_group(part, part)
    end
    file_ref = current_group.new_file(parts.last)
    file_ref.last_known_file_type = 'sourcecode.swift'
    target.source_build_phase.add_file_reference(file_ref)
  end
end

# Resourcesグループ
resources_group = main_group.new_group('Resources', 'Resources')
['poses.json', 'symptoms.json', 'meditations.json'].each do |f|
  ref = resources_group.new_file(f)
  target.resources_build_phase.add_file_reference(ref)
end

# Swiftソース追加
base = File.join(File.dirname(__FILE__), PROJECT_NAME)
add_sources(main_group, base, target, project)

project.save
puts "✅ #{PROJECT_NAME}.xcodeproj を生成しました"
puts "👉 open #{PROJECT_NAME}.xcodeproj"
