
Lit.authentication_function = :authenticate_admin!
Lit.key_value_engine = ENV['LIT_STORAGE'] || 'activesupport'
Lit.fallback = false
Lit.humanize_key = false
Lit.api_enabled = true
Lit.api_key = 'ala'
Lit.all_translations_are_html_safe = true
Lit.init
