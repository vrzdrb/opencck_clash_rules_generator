## Clash meta (mihomo) rule generator by domain/CIDR4 range
The script downloads a list of all IPv4 subnets or domains from https://iplist.opencck.org and formats them for use with Clash clients as a RULE-SET.

## Download:

```bash
curl -o opencck_clash_rules_generator.sh https://raw.githubusercontent.com/vrzdrb/opencck_clash_rules_generator/blob/master/opencck_clash_rules_generator.sh
```
or
```bash
wget https://raw.githubusercontent.com/vrzdrb/opencck_clash_rules_generator/master/opencck_clash_rules_generator.sh
```

## Run:
```bash
./opencck_clash_rules_generator.sh
```

### Mihomo / Clash configuration for domains:

```yaml
sniffer:
  enable: true
  force-dns-mapping: true
  parse-pure-ip: true
  sniff:
    HTTP:
      ports: [80, 8080-8880]
      override-destination: true
    TLS:
      ports: [443, 8443]
rule-providers:
  opencck_domains:
    type: http
    behavior: classical
    format: yaml
    url: https://raw.githubusercontent.com/vrzdrb/opencck_clash_rules_generator/master/domain_clash_rules.yaml
    path: ./opencck/domain_clash_rules.yaml
    interval: 86400
rules:
  - RULE-SET,opencck_domains,PROXY
```

### Mihomo / Clash configuration for CIDR4:

```yaml
sniffer:
  enable: true
  force-dns-mapping: true
  parse-pure-ip: true
  sniff:
    HTTP:
      ports: [80, 8080-8880]
      override-destination: true
    TLS:
      ports: [443, 8443]
rule-providers:
  opencck_CIDR4:
    type: http
    behavior: classical
    format: yaml
    url: https://raw.githubusercontent.com/vrzdrb/opencck_clash_rules_generator/master/IP-CIDR_clash_rules.yaml
    path: ./opencck/IP-CIDR_clash_rules.yaml
    interval: 86400
rules:
  - RULE-SET,opencck_CIDR4,PROXY
```
