.. title:: Nutanix New Hire Training

.. toctree::
  :maxdepth: 2
  :caption: NHT Group Labs
  :name: _labs
  :hidden:

  groupfoundation/foundation
  xray/xray
  ncc/ncc

.. toctree::
  :maxdepth: 2
  :caption: Practice Labs
  :name: _labs
  :hidden:

  diyfoundation/diyfoundation

.. _getting_started:

Getting Started
===============

.. raw:: html

  <strong><font color="red">Do not start any labs before being told to do so by your
  instructor.</font></strong><br><br>

Welcome to Nutanix New Hire Training! Carefully review the **Overview** section of each lab before proceeding with the exercise.

Cluster Access
++++++++++++++

.. note::

  The Foundation lab requires uploading a large file to your Foundation VM, for this reason you are strongly encouraged to connect to the environment using a virtual desktop.

The Nutanix Hosted POC environment can be accessed a number of different ways:

Citrix XenDesktop
.................

https://citrixready.nutanix.com - *Accessible via the Citrix Receiver client or HTML5*

**Nutanix Employees** - Use your NUTANIXDC.local credentials

**Non-Employee** - **Username:** POCxxx-User01 (up to POCxxx-User20), **Password:** *<Instructor Provided>*

VMware Horizon View
...................

https://hostedpoc.nutanix.com - *Accessible via the Horizon View client or HTML5*

**Nutanix Employees** - Use your NUTANIXDC.local credentials

**Partners** - **Username:** POCxxx-User01 (up to POCxxx-User20), **Password:** *<Instructor Provided>*

Employee Pulse Secure VPN
..........................

https://sslvpn.nutanix.com - Use your CORP credentials

Partner Pulse Secure VPN
........................

https://lab-vpn.nutanix.com - **Username:** POCxxx-User01 (up to POCxxx-User20), **Password:** *<Instructor Provided>*

Under **Client Application Sessions**, click **Start** to the right of **Pulse Secure** to download the client.

Install and open **Pulse Secure**.

Add a connection:

- **Type** - Policy Secure (UAC) or Connection Server
- **Name** - HPOC VPN
- **Server URL** - lab-vpn.nutanix.com
