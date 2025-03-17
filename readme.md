# Scheming Symmetry - Evilginx & Nginx Setup

<img src="https://tcgplayer-cdn.tcgplayer.com/product/192521_in_1000x1000.jpg" width="25%">

## Overview
This repository provides a **push-button installer** for setting up **Evilginx, Burp Suite, and Nginx** as a coordinated reverse proxy system. You will need to run these scripts on the associated nginx and evilginx servers.

## Prerequisites
Before running the installer scripts, ensure you have:

1. **Three servers configured:**
   - **Burp Server** (for intercepting traffic from evilginx)
   - **Evilginx Server** (the core of the system, and the middleware)
   - **Nginx Reverse Proxy Server** (the front end on a safe and whitelisted azureedge.net domain)

2. **IP Addresses of Each Server**
   - Required as an argument when running the installation scripts.

3. **Azure CDN Setup**
   - You must create an Azure CDN with the **custom domain** `yourdomain.azureedge.net`. This is used as an argument in both scripts

## Installation
Run the following **on each respective server**:

### **1️⃣ Evilginx Server Setup**
```sh
./evilginx_setup.sh <domain> <ip_addr> <burp_ip_addr>
```
- `<domain>` = Base domain name (e.g., `example`). This is the same as your azureedge subdomain.
- `<ip_addr>` = Evilginx server IP
- `<burp_ip_addr>` = Burp proxy IP

### **2️⃣ Nginx Reverse Proxy Setup**
```sh
./nginx_setup.sh <domain> <full_domain>
```
- `<domain>` = Base domain name (e.g., `example`). This is the same as your azureedge subdomain.
- `<full_domain>` = Fully qualified `nip.io` domain (e.g., `example.192-168-1-1.nip.io`)

## Configuration Details
![Scheming Symmetry](https://raw.githubusercontent.com/twilson-bf/scheming_symmetry/refs/heads/main/image.png)

- **Evilginx:** Handles phishing attacks, TLS termination, and session manipulation.
- **Burp Suite:** Intercepts traffic for further analysis.
- **Nginx:** Acts as a reverse proxy, dynamically routing paths to the correct backend servers.
- **Azure CDN:** Routes requests through `azureedge.net` to obfuscate the final destination.

## Expected Behavior
- Requests to `fid-login.azureedge.net/login` are proxied to Evilginx.
- Requests to `fid-login.azureedge.net/www` are proxied accordingly.
- JavaScript and cookie settings are rewritten to maintain seamless authentication.

## Notes
- Ensure firewall rules **allow traffic on ports 80 and 443**.
- Evilginx requires **root privileges** to function correctly.
- SSL certificates are automatically generated via **Let's Encrypt**.

## Troubleshooting
- **Evilginx Not Responding?** Ensure `sudo evilginx` is running in the background.
- **Nginx Errors?** Check logs: `sudo tail -f /var/log/nginx/error.log`
- **Azure CDN Not Routing?** Double-check DNS mappings in your Azure portal.

---

Enjoy scheming!
```
             .:..::..:.                        ...              ..            ........              
            :::?PBBP?:.:              ..:::^::^:::!7~^^:::::.   ~....       .:.!5GBGY~              
           :::#@@@@@@#:::         .::^:.^Y? 7 ~?. JY??.~.7^.!. !^.    ..   .^ Y@@@@@@@7 .           
           ^.~@@@@@@@@^.^      :^^: ^?! .YJ:J7!77^.7!7 ~^P.^: ~.:::^:.   .~.. G@@@@@@@Y ^.          
           .^ 7B&@@&B! ^.   .:::^^^::PY7~::^:!!^^^^^^^:::!7^ ^:!Y:~:~:::7G&P~ ^P#@@@#J.::           
             :::^~~^.::   :YB?~ ^!~!^~:^~7J5GB##&&&&&#BG5J?~^~.7YJ7J7~5&@@@@@G^ :^~^:.:.            
               ......   :Y&@@@&G?..:~75B&@@@@@&##BB##&@@@@@@#P?~:.7Y&@@@@@@@BJ^. ....               
                       ^?#@@@@@@G!7P&@@@&GY7~:..    ..:~7JP#@@@&G?7G@@@@@#57~   ....                
               ...   .~.:^7G&@G!?B@@@#Y!.                  .~YB@@@#J!G@G5:^ .~.  ....               
              . ..  .~:^^!Y^~7!B@@@B7.   JJ.                   !G@@@#7~:::.:~:~:  ....              
             .. .  .!  ~5^7^:J@@@#7     5@@P                     !B@@@5^^ Y7^J !.  ....             
             . .   ~?!?^~:::5@@@G:     :@@@@~                     .5@@@G^^.~!J7.!   . .             
            . ..  ^^^7J?::^J@@@P       !@@@@?                       Y@@@5::YJ .::~  .::.            
            . .   ! :^^  ~^@@@#.       7@@@@?       .~?Y55555J7~.    G@@@!^:~!7: !  !&B^            
           .. .  .~:77!^::5@@@?        ^@@@@!      .~!~^^^:^^^~!~    !@@@G:^:!~  ~: .~^:            
           .. .  ^^ ::7?^:B@@@^         B@@#.                        .&@@&:^!7 7^:^    .            
           . :~. ^^!:^  ^:#@@&:         ^BB~                         .#@@&^^:?77.:~    .            
           . JG^ :^??7!.^:G@@@~                                      :&@@#:^ 777 ^^    .            
            .    .! ^^~!:^7@@@P^                                    ^Y@@@Y^.^?!~ ~.    .            
            .     ~.JY7!~^:B@@@#55555B#5555B#5555G&5555BB5555B#55555B@@@&^~ ... .!    ..            
            ..    .! !??!.^^&@@&~    J5    ?P    !G    YY    ?P    ^#@@@!^.!!!? ~:    .             
             .     ^^  ~:!Y?~#@@@J   J5    ?P    7G    YY    ?P   7&@@&!7~^Y^!?:~    ..             
              .     ~^.!P&@@Y^P@@@B! J5    ?P    7G    YY    ?P ~G@@@B~J@&BJ~^:~     .              
               .     ~B@@@@@@B^7#@@@GB5    ?P    7G    YY    ?#G@@@#J!B@@@@@&Y^    ..               
             ...:::...^B@@@#P?^:^?B@@@@GJ~.?P    !G    YY.~?P&@@@BJ~:^P@@@@@#!...:::                
            ^.^YB##BY:  JB!:7?7!.^^!YB@@@@&&#YJ?7YB7?JYB&&@@@@#57^.. .!JGY&Y::.7G##BP!              
           :.:&@@@@@@&: ..^:^?^^Y??~:^~?5G#@@@@@@@@@@@@@@&B5J!^.:!7:..^!:^: ^ 5@@@@@@@J :           
           :.^@@@@@@@&:.^  :^::?:..~Y~.~^^^~!7?JYYYYJJ?7~^:..:^~^~:!.::^:  .: P@@@@@@@J ^           
              ^5#&&#5^.^     .:::^.^^^.^Y~?.:^:...:::: .:...J~Y?7^ :^:.   ..  .JB&&&G?.::           
              ..::::.:^:..      .:^:..^~~^J^Y~!: J^7!? !P5 ~^~:!^^:.   ...    ...:^:..:.            
                ....   .::..        .::::^:^:.::.?!!!~.~?7:^:::.    ...         .....               
                         .:::...         ...::::::::::::...     ....                                
                            ..:::...               ^:     .....                                     
                                ..:::::^           ?~                                               
                                     ...                                                            
                                                                                                    
```
