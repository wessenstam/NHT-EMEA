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

The Nutanix Hosted POC environment can only be accessed via VPN or virtual desktop. **It is recommended that the VPN be used to complete these labs.**

GlobalProtect VPN Access
........................

Browse to https://gp.nutanix.com.

Log in with your OKTA credentials.

Download and install the appropriate GlobalProtect agent for your operating system.

Launch GlobalProtect and configure **gp.nutanix.com** as the **Portal** address.

.. note::

  You can also leverage the legacy VPN solution, Pulse Secure. Connect and download the client from https://sslvpn.nutanix.com.

XenDesktop Access
.................

.. note::

  If you are attending NHT and in a non-SE role (e.g. CSM, Services) you DO NOT have NUTANIXDC.local credentials. Alternate credentials will be provided in class to access the HPOC XenDesktop environment.

Download and install the `Citrix Workspace client <https://www.citrix.com/downloads/workspace-app/>`_. Do **NOT** enable Single Sign-On (SSO) during installation.

In your browser, log in at https://citrixready.nutanix.com with your **NUTANIXDC.local** credentials. This username should match your Corp AD (Okta) username (first.last).

The default password is **welcome123**. You will be prompted to change your password.

.. image:: images/1.png

If the default password fails, you can reset your **NUTANIXDC.local** account password by logging into https://rx.corp.nutanix.com using Okta credentials and clicking **Reset NutanixDC.Local Password** in the toolbar.

.. image:: images/2.png

If logon still fails (and you are an SE), contact hostedpoc@nutanix.com to request a **NUTANIXDC.local** account.

Once logged in to https://citrixready.nutanix.com, select **Desktops** from the toolbar and then launch the **EMPLOYEES** desktop.

.. image:: images/3.png

If the Citrix client isn't immediately launched, your browser may have downloaded a **.ica** file without opening it. Open the **.ica** file to launch the Citrix client.

If you receive a certificate error attempting to connect to your Citrix desktop, download and install the `DigiCert SHA2 Secure Server CA <https://dl.cacerts.digicert.com/DigiCertSHA2SecureServerCA.crt>`_ certificate. Restart your browser and attempt to launch your Citrix desktop again.
