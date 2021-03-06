## tese-msc-adhoc

Repositório destinado aos experimentos realizados na pesquisa da tese de mestrado sem redes sem fio AD Hoc

tutorial rapido crição rede MESH com batman

Para criar uma rede mesh usando o protocolo de camada 2 batman.

O batmanb faz parte do kernel linux padrão e desta forma irei configurar o módulo do kernel batman-adv para assumir o controle da interface WiFi wlan0 e criar uma rede mesh sobre WiFi. O Batman-adv irá criar uma nova interface bat0 para permitir que o Pi envie tráfego de rede pela rede mesh. Isso será explicado no discorrer do texto de maneira mais técnica ....

Neste tutorial são usados nós raspberry para simulação e construção da rede. Todos os Raspberry que faram parte da rede mesh, incluindo o gateway caso queira acessar os nós remotamente.

configurção padrão da malha

## Primeira Etapa  (Criando a rede MESH com batman)

#### 1° Atualize o nó

```
sudo apt-get update && sudo apt-get upgrade -y
```

#### 2º Reinicie o Raspberry Pi com o comando

```
sudo reboot -n

```

Depois que o Pi para reinicializado, vá para a linha de comando conecte via ssh é:

```
ssh pi@hostname.local
```

#### 3º Instalando ..


um usuário chamado batctl precisa ser instalado. Isso pode ser feito usando o comando:

```
sudo apt-get install -y batctl

```


```
sudo apt-get install libnl-genl-3-dev
```

```
sudo apt install -y git
```

```
sudo git clone https://github.com/open-mesh-mirror/batctl
```


```
cd batctl
```

```
sudo make install

```

#### Crie um arquivo ~ / start-batman-adv.sh

por exemplo

```
nano ~/start-batman-adv.sh

``` 

O arquivo deve conter o seguinte:

```
#!/bin/bash
# batman-adv interface to use
sudo batctl if add wlan0
sudo ifconfig bat0 mtu 1468

# Tell batman-adv this is a gateway client
sudo batctl gw_mode client

# Activates batman-adv interfaces
sudo ifconfig wlan0 up
sudo ifconfig bat0 up

```


#### 5° Torne o arquivo start-batman-adv.sh executável com o comando:

```
chmod +x ~/start-batman-adv.sh

```


#### 6º Crie a definição da interface de rede para uma interface wlan0 criando um arquivo como usuário root, por exemplo

```
sudo vi /etc/network/interfaces.d/wlan0

```

```
sudo nano /etc/network/interfaces.d/wlan0

```

em seguida, acesso ao conteúdo a seguir:

```
auto lo
iface lo inet loopback

iface eth0 inet dhcp

auto wlan0
iface wlan0 inet static
  address 10.2.1.1
  netmask 255.255.255.0
  wireless-channel 1
  wireless-essid jam-adhoc
  wireless-mode ad-hoc
```


OBS ::: Esses valores devem ser os mesmos em TODOS os dispositivos que formarão sua rede mesh.


#### 7º certifique-se de que o módulo do kernel batman-adv seja carregado no momento da inicialização, emitindo o seguinte comando:

```
echo 'batman-adv' | sudo tee --append /etc/modules

```

#### 8º Impeça o processo DHCP de tentar gerenciar uma interface LAN sem fio, emitindo o seguinte comando:

```
echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf

```

#### 9º Certifique-se de que o script de inicialização seja chamado editando o arquivo /etc/rc.local como usuário root, por exemplo

```
sudo nano /etc/rc.local

```

e insira: antes da última linha: saída 0

```
/home/pi/start-batman-adv.sh & 
```

## O mais importatnmte... hehe

rode o arquio batman-adv.sh

```
sudo ~/start-batman-adv.sh

```
## Comandos importantes

A interface "bat0" pode ser usada como qualquer outra interface regular. 
Esta por sua vez necessita de um endereço IP que pode ser configurado estaticamente 
ou dinamicamente (usando DHCP ou serviços semelhantes): 

No A: ip link set up dev bat0 

No A : ip addr add 192.168.0.1/24 dev bat0 


No B: ip link configurar dev bat0

No B: ip addr add 192.168.0.2/24 dev bat0 

No B: ping 192.168.0.1 

Nota: Para evitar problemas, remova todos os endereços IP anteriormente 
atribuídos às interfaces agora usadas pelo batman, por exemplo, 

sudo ip addr flush dev wlan0


# Terceira etapa -- crição automática da rede
