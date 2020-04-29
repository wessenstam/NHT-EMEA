.. title:: Nutanix New Hire Training

.. toctree::
  :maxdepth: 2
  :caption: Labs
  :name: _labs1
  :hidden:

  nutanix101/nutanix101

.. toctree::
  :maxdepth: 2
  :caption: Labs of Choice
  :name: _labs2
  :hidden:
  
  files/files
  calm/calm
  flow/flow
  era/era
  karbon/karbon

.. toctree::
  :maxdepth: 2
  :caption: Appendix
  :name: _labsA
  :hidden:
  
  tools_vms/linux_tools_vm
  tools_vms/windows_tools_vm
  taskman/taskman


.. _getting_started:

Getting Started
===============

.. raw:: html

  <strong><font color="red">Do not start any labs before being told to do so by your
  instructor.</font></strong><br><br>

Welcome to Nutanix New Hire Training! Carefully review the **Overview** section of each lab before proceeding with the exercise.

.. note::
  Shown screenshots are there for example purposes! Use **your** information!

.. _cluster_details:

Cluster Access
++++++++++++++

To make sure you use your IP addresses, naming and other information please use the below spreadsheet.
For the IP address of your assigned Cluster use the IP Address in the Cluster IP column.

.. raw:: html

  <iframe src="https://docs.google.com/a/nutanix.com/spreadsheets/d/e/2PACX-1vTohdHcbfSzB65Z1C8d7cAJEmDcZs5DDvUtsXPoezVwdLwOWHipU_Nu8U7ft1DmInKpnAvqWUP_ZfSd/pubhtml?gid=0&amp;single=true&amp;widget=true&amp;headers=false" style="position: relative; height: 600px; width: 98%; border: none"></iframe>

.. note::
    Write down your IP addresses on a piece of paper to make it a bit easier for yourself...

The Nutanix Hosted Proof of Concept (HPOC) environment can only be accessed via a Frame session or by connecting to the **NTNX_corp** network using VPN if you are remote.

Frame session
..............

1. Login to https://frame.nutanix.com/x/labs using your supplied credentials from the Columns **Frame User** and **password**.
2. Accept the **Nutanix Cloud Services Term of Services** by clicking on the **I Accept** button.
3. Double click on the *Desktop* icon to start your Frame Session.
4. This will give you a 6 hour windows for your labs. In the Windows 10 session you should have all tools needed for the labs pre-installed
   
   .. figure:: images/Framesession.png
  

GlobalProtect VPN Access
........................

Browse to https://gp.nutanix.com.

Log in with your OKTA credentials.

Download and install the appropriate GlobalProtect agent for your operating system.

Launch GlobalProtect and configure **gp.nutanix.com** as the **Portal** address.
