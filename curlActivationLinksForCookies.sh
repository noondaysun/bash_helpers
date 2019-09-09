#! /bin/bash

# todo better implementation here
FILE=/tmp/merchants.json
USER=78

jq '.merchants[].activation_url' "${FILE}" | while read -r line; do
  line=${line//\"/}
  merchant_id=$(echo "${line}" | cut -d/ -f 5)
  network=$(echo "${line}" | cut -d/ -f 6)
  cookiejar="/tmp/${network}.${merchant_id}"

  if [[ -e "${cookiejar}" ]]; then
    continue
  fi

  uri="https://quidco.local.syrupme.net/api-visit/${merchant_id}/${USER}"
  echo "Visiting ${uri}"
  curl -ksL --cookie-jar "${cookiejar}" "${uri}" > /dev/null
done

networks=('AD' 'AF' 'AFFS' 'AFN' 'AFNIE' 'AILPL' 'AMAZ' 'APPL' 'AV' 'AWh' 'AWIE' 'AWPL' 'AWq' 'BA' 'BAh' 'BKC' 'BKCPL' 'BTTN' 'CJ' 'CJh' 'CJIE' 'CLG' 'CNT' 'COS' 'CPR' 'CW7' 'DGM' 'DSG' 'DT' 'E2S' 'ELX' 'EPN' 'GOOG' 'GRPN' 'IR' 'ITU' 'KLM' 'LS' 'LSIE' 'M3' 'MA' 'MAX' 'MC' 'MEC' 'MON' 'MST' 'NAFPL' 'None' 'NSPL' 'OGi' 'OMD' 'OMG' 'OMNI' 'PH' 'PHC' 'PHD' 'PLANB' 'PLT' 'PNLBS' 'POR' 'PP' 'QCO' 'QCOP' 'QCRU' 'QOP' 'QTM' 'RCK' 'RTV' 'S20' 'Seopa' 'SME' 'SMG' 'SMPL' 'ST' 'STK' 'SUM' 'SW' 'TAG' 'TDh' 'TDIE' 'TDPL' 'TDq' 'TT' 'TTIE' 'TTPL' 'UKWM' 'VISA' 'VSO' 'WG' 'WGIE' 'WH' 'WM' 'WOW' 'ZNO' 'ZNX' 'ZNXPL')
for i in "${networks[@]}"; do
    echo "Checking for common cookies for network ${i}"
    perl -ne 'print if ($seen{$_} .= @ARGV) =~ /10$/' /tmp/"${i}"*
    echo "---------------------------------------------------------------------"
done