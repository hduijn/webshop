<?php

require_once('dns.php');
require_once('Transip/DomainService.php');

// define domains array
$domain_array = array("test.repairwebshop.nl");

// vars
$backuplocation = '/opt/letsencryptssl/dnsbackups/';
$sub = '';

foreach($domain_array as $domain) {

  // fetch all domain names that we can manage.
  try {
    $domains = Transip_DomainService::getDomainNames();
  }
  catch (SoapFault $e) {
    echo $e->getMessage() . PHP_EOL;
    exit(1);
  }

  // get different domain names.
  $regex_domains = $domains;
  if (1 !== preg_match('/^((.*)\.)?(' . implode('|', array_map('preg_quote', $domains)) . ')$/', $domain, $matches)) {
    echo 'Can\'t manage DNS for given domain (' . $domain . ').' . PHP_EOL;
    exit(1);
  }
  $base_domain = $matches[3];
  $subdomain = $matches[2];

  // fetch alle DNS entries.
  try {
    $info = Transip_DomainService::getInfo($base_domain);
    $dnsEntries = $info->dnsEntries;
    if (!is_array($dnsEntries)) {
        $dnsEntries = array($dnsEntries);
    }
    // make backups 
    $filename = $backuplocation.$base_domain.'_';
    file_put_contents ( $filename.'latest', serialize($dnsEntries));
    file_put_contents ( $filename.'latest'.'.json' , json_encode($dnsEntries,JSON_PRETTY_PRINT));
    file_put_contents ( $filename.date("Y-m-d") , serialize($dnsEntries));
    file_put_contents ( $filename.date("Y-m-d").'.json' , json_encode($dnsEntries,JSON_PRETTY_PRINT));

  }
  catch (SoapFault $e) {
    echo $e->getMessage() . PHP_EOL;
    exit(1);
 }

  // add CAA record if none found
  if ($subdomain == ""){
    $caa_domain = "@";
  } else {
    $caa_domain = $subdomain;
    $sub = $subdomain.'.';
  }

  $dns_result = dns_get_record($sub.$domain, DNS_CAA);
  if (count($dns_result) == 0){
    $dnsEntries[] = new Transip_DnsEntry($caa_domain, 86400, Transip_DnsEntry::TYPE_CAA, '0 issue "letsencrypt.org"');
  }

  // save new DNS records
  try {
  Transip_DomainService::setDnsEntries($base_domain, $dnsEntries);
  }
  catch (SoapFault $e) {
    echo $e->getMessage() . PHP_EOL;
    exit(1);
  }
}


exit(0);


