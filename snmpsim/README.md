# SNMPSIM 使用tips

## 产生SNMP 快照方法
  * snmpsim 使用SNMP快照来模拟snmp client 的数据，通常是使用snmprec 工具通过特定版本的snmp协议对生产或者实际设备的特定范围的OID做getnext 查询，然后把数据记录下来。

  * SNMP快照数据类似下面内容（每行数据以`|`分隔)  
        1.3.6.1.2.1.1.1.0|4|Linux 2.6.25.5-smp SMP Tue Jun 19 14:58:11 CDT 2007 i686
        1.3.6.1.2.1.1.2.0|6|1.3.6.1.4.1.8072.3.2.10
        1.3.6.1.2.1.1.3.0|67|233425120
        1.3.6.1.2.1.2.2.1.6.2|4x|00127962f940
        1.3.6.1.2.1.4.22.1.3.2.192.21.54.7|64x|c3dafe61

  * 第一列数据是OID
  * 第二列数据是数据类型（编码过的ASN.1 TAG，如果以X结尾，则是以16进制表示。

        Integer32 - 2
        OCTET STRING - 4
        NULL - 5
        OBJECT IDENTIFIER - 6
        IpAddress - 64
        Counter32 - 65
        Gauge32 - 66
        TimeTicks - 67
        Opaque - 68
        Counter64 - 70

  * 第三列是数据值

    ### 抓取快照命令示范
    使用demo.snmplabs.com 在线的snmp设备（模拟）来抓取快照  
    `snmprec.py --agent-udpv4-endpoint=demo.snmplabs.com --use-getbulk
--output-file=data/recorded/linksys-system.snmprec`

    ### 常见的快照文件
    * .snmprec    snmprec生成
    * .snmpwalk   snmpwalk生成
    * .sapwalk
    * .dbm        一般放在临时目录，oid索引文件，加快OID查询速度。

    ### 参考
    1. [烂泥：使用snmpwalk采集设备的OID信息](http://www.ilanni.com/?p=8408)  
    2. [SNMP v1，v2，v3 的比较](http://blog.163.com/fan_yishan/blog/static/4769221320091029197400/)
    3. [Producing SNMP snapshots](http://snmpsim.sourceforge.net/snapshotting.html)  

    ### 该目录文件说明
    1. 使用01_installsnmpsim.sh 安装snmpsim
    2. 使用02_start_snmpsim_with_multi_ip.sh 来模拟在多个IP模拟snmp设备，后台运行后会列出监听的IP和端口，默认community 是public.
