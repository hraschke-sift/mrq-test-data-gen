#!/bin/bash

source ./env.sh

type=$1
id=${2:-1}
uuid=$(uuidgen)

content=$(cat <<EOF
{
  "\$type": "\$create_content",
  "\$api_key": "$API_KEY",
  "\$user_id": "mrqtest-cont-user-$uuid-$id",
  "\$content_id": "mrqtest-content-$uuid-$id",
  "\$comment": {
    "\$body": "some text"
  },
  "\$app": {
    "\$app_name": "app2"
  }
}
EOF
)

session=$(cat <<EOF
{
  "\$type": "\$login",
  "\$api_key": "$API_KEY",
  "\$user_id": "mrqtest-ato-user-$uuid-$id",
  "\$login_status": "\$success",
  "\$session_id": "mrqest-session-$uuid-$id"
}
EOF
)

order=$(cat <<EOF
{
  "\$order_id": "mrq-order-$uuid-$id",
  "\$user_email": "mrg11@gmail.com",
  "\$amount": 33,
  "\$currency_code": "EUR",
  "\$billing_address": {
    "\$address_1": "Hohenkraehenstrasse cat doog 14",
    "\$city": "Singen",
    "\$region": "BADEN-WUERTTEMBERG",
    "\$country": "DE",
    "\$zipcode": "78224"
  },
  "\$payment_methods": [
    {}
  ],
  "\$browser": {
    "\$user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36"
  },
  "\$user_id": "mrqtest-payment-user-$uuid-$id",
  "\$session_id": "d2a589c7-69cd-41bc-93d7-4c4da47afwww_1",
  "\$ip": "78.43.219.8",
  "\$type": "\$create_order",
  "\$api_key": "$API_KEY"
}
EOF
)

case $type in
  "content")
    echo $content
    ;;
  "session")
    echo $session
    ;;
  "order")
    echo $order
    ;;
  "user")
    echo $order
    ;;
  *)
    echo $order
    ;;
esac
