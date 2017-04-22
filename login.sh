#!/bin/bash
##[ Ficha ]##########################
#
# Nome: script_inicializacao
#
# Escrito por: Spolti
#
# Criado em: 05/08/2009
#
# Ultima atualizacao 07/08/2009
#
##[ Descricao ]########################
#
# Script tem a finalidade de auxiliar a configuracao
# de um sistema operacional Linux Centos
# recem instalado.
#
##################################
opcao=" "
num=" "
var=" "
# -- VOCE EH O ROOT?
  if test "$UID" != "0"; then
   echo "Voce nao e root, saindo "
   echo -n "`sleep 0.5`"  
   exit 0      
  fi
if [ ! -e /var/log/script_inicializacao.log ]; then
   echo -n "Script executado pela primeira vez, criando arquivos necessarios "
   `touch /var/log/script_inicializacao.log`
fi
echo  "Scrip para configuracao inicial do sistema."
echo -n "`sleep 0.3`"
echo -n "Carregando informacoes "
echo -n "`sleep 0.5`"
echo -n "      [ OK ]"
echo "`sleep 0.3`"
echo "Todas as alteracoes serao armazenadas em /var/log/script_inicializacao.log"
echo -n "`sleep 0.3`"
echo "Diretorio atual: `pwd`"
echo -n "`sleep 0.3`"
echo "Usuario logado: $USER"
echo -n "`sleep 0.3`"
echo "PID $$"
echo -n "`sleep 0.3`"
echo "Console $SSH_TTY"
echo -n "`sleep 0.3`"
var=$SSH_CLIENT
echo "Logged from: `echo $var | sed 's/ /./g' | cut -d. -f1-4`"
IP=`echo $var | sed 's/ /./g' | cut -d. -f1-4`
datevar=`date`
echo -n "`sleep 0.3`"
`echo "O usuario $USER executou o script_inicializacao.sh em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
echo -n "Pressione Enter para continuar."
read
echo -n "Deseja setar hostname ? [s/n]  >  "
read opcao
if [ "$opcao" = "s" ]; then
hostname=" "
   echo -n "Digite o hostname  >   "
   read hostname
   `echo NETWORKING=yes > /etc/sysconfig/network`
        `echo NETWORKING_IPV6=yes >> /etc/sysconfig/network`
        `echo HOSTNAME=$hostname >> /etc/sysconfig/network`
        `echo '# Do not remove the following line, or various programs' > /etc/hosts`
        `echo '# that require network functionality will fail.' >> /etc/hosts`
        `echo '127.0.0.1       localhost.localdomain       localhost   '$hostname'' >> /etc/hosts`
   `echo "O usuario $USER configurou hostname $hostname em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
      elif [ "$opcao" = "n" ]; then
         `echo "O usuario $USER nao configurou hostname em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi
echo -n "Sua rede possui proxy? [s/n]  >  "
read opcao
if [ "$opcao" = "s" ]; then
ip=" "
port=" "
        echo -n "Digite o ip [xxx.xxx.xxx.xxx]  >  "
        read ip
        echo -n "Digite a porta  >  "
        read port
        `echo 'jz/bin/bash' > temp`
        `cat  temp | sed 's/jz/#!/g' >> temp`
        `awk 'FNR> 1' temp > /etc/profile.d/proxy.sh`
        `rm -rf temp`
        `echo export http_proxy='"'http://$ip:$port'"' >> /etc/profile.d/proxy.sh`
        `echo export ftp_proxy='"'http://$ip:$port'"' >> /etc/profile.d/proxy.sh`
        `echo export https_proxy='"'http://$ip:$port'"' >> /etc/profile.d/proxy.sh`
        `chmod u+x /etc/profile.d/proxy.sh`
        `source /etc/profile.d/proxy.sh`
   `echo "O usuario $USER configurou o proxy $ip na porta $port em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
                 elif [ "n" = "$opcao" ]; then
         `echo "O usuario $USER nao configurou proxy em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi
echo -n "Deseja configurar DNS? [s/n]  >  "
read opcao
if [ "s" = "$opcao" ] ;then
   i=0
   ipdns=" "
   dominio=" "
   echo -n "Quantos servidores possuem a rede? [1,2,...]  >  "
   read num
   echo -n "Digite o dominio  >  "
   read dominio
   `echo "O usuario $USER configurou dominio $dominio em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
   `echo search $dominio > /etc/resolv.conf`
      while test "$num" -gt "$i" ; do
         echo -n "Digite o Ip do DNS Server [ xxx.xxx.xxx.xxx ]  >  "
         read ipdns
         `echo nameserver $ipdns >> /etc/resolv.conf`
         i=`expr $i + 1`
         `echo "O usuario $USER configurou o IP $ipdns como SERVER DNS em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
      done
      else
         `echo "O usuario $USER nao configurou DNS e Dominio em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi
echo -n "Deseja configurar Data? [s/n]  >  "
read opcao
if [ "$opcao" = "s" ]; then
   echo -n "Digite a hora/data no formato [ mm/dd/aaaa hh:mm ]  >  "
   read data
   echo " `date -s "$data"` "
   datevar=`date`
   `echo "O usuario $USER configurou data/hora para $data em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
   else
      `echo "O usuario $USER nao configurou data/hora em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi
echo -n "Deseja inserir um servidor NTP? [ s/n ]  >  "
read opcao
if [ "s" = "$opcao" ]; then
ipntp=" "
        echo -n "Digite o IP do servidor NTP [ xxx.xxx.xxx.xxx ]  >  "
        read ipntp
        echo "`ntpdate -u -v $ipntp`"
   `echo "O usuario $USER configurou servidor NTP $ipntp em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
   else
      `echo "O usuario $USER nao configurou servidor NTP em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi
echo -n "Deseja criar cron para NTPdate? [ s/n ]  >  "
read opcao
if [ "s" = "$opcao" ]; then
        `echo "00-59/01 * * * * /usr/sbin/ntpdate -u -v $ipntp" > temp1`
        `crontab temp1`
        echo "O comando ntpdate foi inserido na cron, sera executado de 1 em 1 minuto."
        echo "pressione Enter para continuar"
        `rm -rf temp1`
        `echo "O usuario $USER configurou cron NTP em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
        read
        else
                `echo "O usuario $USER nao configurou cron  em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi

echo -n "Deseja setar IP fixo ? [s/n]  >  "
read opcao
if [ "$opcao" = "s" ]; then
ip=" "
        echo -n "Digite o IP [ xxx.xxx.xxx.xxx ]  >   "
        read ip
        echo -n "Digite a mascara [ xxx.xxx.xxx.xxx ]  >   "
        read mask
        echo -n "Difite o default gateway [ xxx.xxx.xxx.xxx ]  >   "
        read gw
        `echo '#Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE]' > /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo DEVICE=eth0 >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo BOOTPROTO=none >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        var=`ifconfig | head -1 | sed 's/ /#/g' | cut -d# -f11`
        `echo HWADDR=$var >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo IPV6_AUTOCONF=yes >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo TYPE=Ethernet >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo NETMASK=$mask >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo IPADDR=$ip >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo GATEWAY=$gw >> /etc/sysconfig/network-scripts/ifcfg-eth0`
        `echo "O usuario $USER configurou o IP $ip $datevar logado na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
                elif [ "$opcao" = "n" ]; then
                        echo "Ip atribuito por DHCP"
                        `echo '#Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE]' > /etc/sysconfig/network-scripts/ifcfg-eth0`
                        `echo DEVICE=eth0 >> /etc/sysconfig/network-scripts/ifcfg-eth0`
                        `echo BOOTPROTO=dhcp >> /etc/sysconfig/network-scripts/ifcfg-eth0`
                        var=`ifconfig | head -1 | sed 's/ /#/g' | cut -d# -f11`
                        `echo HWADDR=$var >> /etc/sysconfig/network-scripts/ifcfg-eth0`
                        `echo IPV6INIT=yes >> /etc/sysconfig/network-scripts/ifcfg-eth0`
                        `echo IPV6_AUTOCONF=yes >> /etc/sysconfig/network-scripts/ifcfg-eth0`
                        `echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-eth0`
                        `echo TYPE=Ethernet >> /etc/sysconfig/network-scripts/ifcfg-eth0`
         `echo "O usuario $USER atribuiu IP via DHCP em $datevar logado na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
fi

echo "Para nao reiniciar o computador pressione Ctrl+c, "
echo "porem e recomendavel reinicar."
echo "Para reniciar tecle Enter."
read
echo -n "O computador sera reiniciado em 10 segundos para aplicar as configuracoes realizadas "
for i in `seq 10`
do
        clear
        echo "$i"
        `sleep 1`
done
`echo "Computador reiniciado por $USER em $datevar na console $SSH_TTY de $IP;" >> /var/log/script_inicializacao.log`
`reboot`
