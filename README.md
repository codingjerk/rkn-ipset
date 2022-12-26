# Roskomnadzor: Automatic ipset filling

## Usage

### Manual

1. Run `update.sh` script which will create "blocked" ipset's set for ipv4, "blocked6" for ipv6 and "blocked-list" for superset
2. Create iptables rules to redirect traffic

### Tor example

/etc/iptables/iptables.rules:
```
-A PREROUTING ! -i lo -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m set --match-set blocked dst -j REDIRECT --to-ports 9040
-A OUTPUT -m owner --uid-owner "tor" -j RETURN
-A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m set --match-set blocked dst -j REDIRECT --to-ports 9040
```
