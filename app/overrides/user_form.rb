Deface::Override.new(:virtual_path => "spree/shared/_user_form",
                     :name         => "user_form_subscription",
                     :insert_after => "[data-hook=subscription_form_account]",
                     :partial      => "spree/shared/user_subscription")

Deface::Override.new(:virtual_path => "spree/home/newindex",
                     :name         => "spree_chimpy_subscription_form_home",
                     :insert_bottom => "[data-hook=subscription_form]",
                     :partial      => "spree/shared/guest_subscription")

Deface::Override.new(:virtual_path => "spree/info/newsletter",
                     :name         => "spree_chimpy_subscription_form_lightbox",
                     :insert_bottom => "[data-hook=subscription_form]",
                     :partial      => "spree/shared/guest_subscription")

Deface::Override.new(:virtual_path => "spree/shared/_landing_cadastro",
                     :name         => "spree_chimpy_subscription_form_landing",
                     :insert_bottom => "[data-hook=subscription_form]",
                     :partial      => "spree/shared/guest_subscription2")