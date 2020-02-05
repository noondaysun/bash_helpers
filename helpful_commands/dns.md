## DNS

** Scan a domain for subdomains with nmap **

```
DOMAIN=domain.tld nmap --script dns-brute --script-args dns-brute.domain=${DOMAIN},dns-brute.threads=6
```