.. title:: Nutanix New Hire Training

.. toctree::
  :maxdepth: 2
  :caption: Labs
  :name: _labs1
  :hidden:

  nutanix101/nutanix101

  .. ncc-ui/ncc-ui
    foundation-part-1/part1
    setup-cluster/setup-cluster
    ncc-cmdl/ncc-cmdl
    xray/xray
    foundation-part-2/part2
    deployment/deployment


    .. toctree::
    :maxdepth: 2
    :caption: Day 2 - Labs of Choice
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

The Nutanix Hosted Proof of Concept (HPOC) environment can only be accessed via VPN or by connecting to the **NTNX_corp** network.

GlobalProtect VPN Access
........................

Browse to https://gp.nutanix.com.

Log in with your OKTA credentials.

Download and install the appropriate GlobalProtect agent for your operating system.

Launch GlobalProtect and configure **gp.nutanix.com** as the **Portal** address.
