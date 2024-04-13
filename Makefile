
get:
	echo "╠ Installing dependencies..."
	flutter pub get
	make ios_install
	make macos_install

outdated:
	echo "╠ Resolving dependencies..."
	flutter pub outdated

clean: ## Cleans the environment
	echo "╠ Cleaning the project..."
	flutter clean
	echo "╠ Installing dependencies..."
	make get

install:
	make npm_install
	make ios_install
	make macos_install

npm_install:
	echo "╠ Resolving npm dependencies..."
	cd docs && pnpm i && cd ..

ios_install: ## Installing ios dependencies
	echo "╠ Resolving ios dependencies..."
	cd ios && pod install && cd ..

macos_install: ## Installing ios dependencies
	echo "╠ Resolving macos dependencies..."
	cd macos && pod install && cd ..

icon: ## Generate icons
	echo "╠ Generate icons..."
	dart run flutter_native_splash:create

build_watch: ## Watches the files for changes
	echo "╠ Watching the project..."
	dart run build_runner watch --delete-conflicting-outputs

build_runner: ## Build the files for changes
	echo "╠ Building the project..."
	dart run build_runner build --delete-conflicting-outputs

clean_runner: ## Deleting cache and generated source files
	echo "╠ Deleting cache and generated source files..."
	dart run build_runner clean

apk: ## Release Apk
	echo "╠ Releasing Apk..."
	bash build-android.sh && flutter build apk --no-tree-shake-icons --flavor staging

appbundle: ## Release Appbundle
	echo "╠ Releasing Appbundle..."
	flutter build appbundle --no-tree-shake-icons --flavor production

adhoc:
	echo "╠ Removing build products and intermediate files from the build root..."
	cd ios && xcodebuild clean && cd ..
	echo "╠ Releasing to adhoc..."
	bash build-ios.sh && flutter build ipa --export-options-plist=ios/ExportOptions-debug.plist

appstore:
	echo "╠ Removing build products and intermediate files from the build root..."
	cd ios && xcodebuild clean && cd ..
	echo "╠ Removing BuildConfig.xcconfig..."
	rm -f ios/Flutter/BuildConfig.xcconfig
	echo "╠ Releasing to app store..."
	flutter build ipa --export-options-plist=ios/ExportOptions-release.plist

macos_adhoc:
	echo "╠ Removing build products and intermediate files from the build root..."
	cd macos && xcodebuild clean && cd ..
	echo "╠ Releasing bundle..."
	bash build-macos.sh && flutter build macos && bash build-dmg.sh

macos_appstore:
	echo "╠ Removing build products and intermediate files from the build root..."
	cd macos && xcodebuild clean && cd ..
	echo "╠ Removing BuildConfig.xcconfig..."
	rm -f macos/Flutter/BuildConfig.xcconfig
	echo "╠ Releasing bundle..."
	flutter build macos && bash build-dmg.sh
