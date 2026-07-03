# Project Init

This file records the initial app files that were introduced or copied into the Saabi Mobile workspace.

## App shell
- [lib/app.dart](lib/app.dart) - app root placeholder.
- [lib/main.dart](lib/main.dart) - current entrypoint bootstrapping the copied shell.
- [lib/features/splash.dart](lib/features/splash.dart) - splash placeholder screen.

## Shared layout and controls
- [lib/shared/components/layout/app_scaffold.dart](lib/shared/components/layout/app_scaffold.dart) - shared scaffold wrapper.
- [lib/shared/components/layout/app_text.dart](lib/shared/components/layout/app_text.dart) - reusable text widget.
- [lib/shared/components/layout/app_padding.dart](lib/shared/components/layout/app_padding.dart) - shared spacing helper.
- [lib/shared/components/layout/snappable_h_page_view.dart](lib/shared/components/layout/snappable_h_page_view.dart) - horizontal paging helper.
- [lib/shared/components/buttons/app_button.dart](lib/shared/components/buttons/app_button.dart) - reusable button primitive.
- [lib/shared/components/buttons/build_icon_button.dart](lib/shared/components/buttons/build_icon_button.dart) - icon button helper.
- [lib/shared/components/buttons/scale_click_wrapper.dart](lib/shared/components/buttons/scale_click_wrapper.dart) - tap feedback wrapper.
- [lib/shared/components/inputs/app_text_form_field.dart](lib/shared/components/inputs/app_text_form_field.dart) - reusable text field wrapper.
- [lib/shared/components/inputs/custom_textfield.dart](lib/shared/components/inputs/custom_textfield.dart) - custom text field variant.
- [lib/shared/components/sheets/app_bottom_sheet.dart](lib/shared/components/sheets/app_bottom_sheet.dart) - bottom sheet wrapper.
- [lib/shared/components/indicators/app_circular_loading_indicator.dart](lib/shared/components/indicators/app_circular_loading_indicator.dart) - loading indicator wrapper.

## Dialogs and pages
- [lib/shared/components/dialogs/app_dialog.dart](lib/shared/components/dialogs/app_dialog.dart) - base dialog wrapper.
- [lib/shared/components/dialogs/app_dialog_container.dart](lib/shared/components/dialogs/app_dialog_container.dart) - dialog container shell.
- [lib/shared/components/dialogs/src/app_action_dialog.dart](lib/shared/components/dialogs/src/app_action_dialog.dart) - action dialog implementation.
- [lib/shared/components/dialogs/src/app_alert_dialog.dart](lib/shared/components/dialogs/src/app_alert_dialog.dart) - alert dialog implementation.
- [lib/shared/components/dialogs/src/loading_dialog.dart](lib/shared/components/dialogs/src/loading_dialog.dart) - loading dialog implementation.
- [lib/shared/components/dialogs/src/result_dialog.dart](lib/shared/components/dialogs/src/result_dialog.dart) - result dialog implementation.
- [lib/shared/components/dialogs/src/sign_out_dialog.dart](lib/shared/components/dialogs/src/sign_out_dialog.dart) - sign-out confirmation dialog.
- [lib/shared/components/pages/error_page.dart](lib/shared/components/pages/error_page.dart) - global error page.

## Routing
- [lib/shared/routes/app_router.dart](lib/shared/routes/app_router.dart) - GoRouter provider and app route registry.
- [lib/shared/routes/routes.dart](lib/shared/routes/routes.dart) - route enum exports.
- [lib/shared/routes/auto_route.dart](lib/shared/routes/auto_route.dart) - route builder helpers.
- [lib/shared/routes/src/splash_route.dart](lib/shared/routes/src/splash_route.dart) - splash route definition.

## Theme
- [lib/shared/theme/app_theme.dart](lib/shared/theme/app_theme.dart) - shared theme entrypoint.
- [lib/shared/theme/src/app_colors.dart](lib/shared/theme/src/app_colors.dart) - semantic app color tokens.

## Core helpers
- [lib/core/assets/assets.dart](lib/core/assets/assets.dart) - asset helpers and export.
- [lib/core/assets/assets.gen.dart](lib/core/assets/assets.gen.dart) - placeholder generated assets file.
- [lib/core/constants/constants.dart](lib/core/constants/constants.dart) - shared constant barrel.
- [lib/core/constants/enums/enums.dart](lib/core/constants/enums/enums.dart) - shared enum barrel.
- [lib/core/storage/hive/hive_keys.dart](lib/core/storage/hive/hive_keys.dart) - Hive key definitions.
- [lib/core/storage/src/app_paths.dart](lib/core/storage/src/app_paths.dart) - application storage paths.
- [lib/core/utils/network/network_utils.dart](lib/core/utils/network/network_utils.dart) - network helpers.
- [lib/core/utils/ui/ui_utils.dart](lib/core/utils/ui/ui_utils.dart) - UI helper utilities.

## Feature placeholders
- [lib/dev/web_clone/app.dart](lib/dev/web_clone/app.dart) - copied web-clone shell.
- [lib/dev/web_clone/pages/dashboard_page.dart](lib/dev/web_clone/pages/dashboard_page.dart) - dashboard mock screen.
- [lib/dev/web_clone/pages/landing_page.dart](lib/dev/web_clone/pages/landing_page.dart) - landing mock screen.
- [lib/dev/web_clone/pages/investment_page.dart](lib/dev/web_clone/pages/investment_page.dart) - investment mock screen.