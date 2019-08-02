.. _xray_lab:

-----
X-Ray
-----

Overview
++++++++

.. note::

  Estimated time to complete: **45 Minutes**

X-Ray is an automated testing application for virtualized infrastructure solutions. It is capable of running test scenarios end-to-end to evaluate system attributes in real-world use cases. In this exercise you will deploy and configure an X-Ray VM, run X-Ray tests, and analyze results.

As X-Ray powers down hosts for tests that evaluate availability and data integrity, it is best practice to run the X-Ray VM outside of the target cluster. Additionally, the X-Ray VM itself creates a small amount of storage and CPU overhead that could potentially skew results.

For environments where DHCP is unavailable (or there isn't a sufficiently large pool of addresses available), X-Ray supports `Link-local <https://en.wikipedia.org/wiki/Link-local_address>`_ or "Zero Configuration" networking, where the VMs communicate via self-assigned IPv4 addresses. In order to work, all of the VMs (including the X-Ray VM) need to reside on the same Layer 2 network. To use Link-local networking, your X-Ray VM's first NIC (eth0) should be on a network capable of communicating with your cluster. A second NIC (eth1) is added on a network without DHCP.

Cluster Details
...............

Using the spreadsheet below, locate your IP Address of the assigned cluster and corresponding details.

.. raw:: html

   <iframe src="https://docs.google.com/a/nutanix.com/spreadsheets/d/e/2PACX-1vTohdHcbfSzB65Z1C8d7cAJEmDcZs5DDvUtsXPoezVwdLwOWHipU_Nu8U7ft1DmInKpnAvqWUP_ZfSd/pubhtml?gid=0&amp;single=true&amp;widget=true&amp;headers=false" style="position: relative; height: 400px; width: 98%; border: none"></iframe>

References and Downloads
........................

The following links are provided for reference and not required to complete the lab exercise.

- `X-Ray Guide <https://portal.nutanix.com/#/page/docs/details?targetId=X-Ray-Guide-v33:X-Ray-Guide-v33>`_ - *X-Ray documentation*
- `X-Ray Downloads <https://portal.nutanix.com/#/page/static/supportTools>`_ - *Portal location to download the latest X-Ray OVA and QCOW2 images.*
- `X-Ray Vision as Nutanix Goes Open Source <https://www.nutanix.com/2018/05/09/x-ray-vision-as-nutanix-goes-open-source/>`_ - *Nutanix blog article explaining the impact of open sourcing X-Ray.*
- `Nutanix GitLab Page <https://gitlab.com/nutanix>`_ - *Public facing repository of opensource X-Ray components including scenarios and Curie engine.*
- `HCI Performance Testing Made Easy (Part 1) <https://www.n0derunner.com/2018/09/hci-performance-testing-made-easy-part-1/>`_ - *Gary Little blog/video series on using X-Ray.*
- `HCI Performance Testing Made Easy (Part 2) <https://www.n0derunner.com/2018/09/hci-performance-testing-made-easy-part-2/>`_ - *Gary Little blog/video series on using X-Ray.*
- `HCI Performance Testing Made Easy (Part 3) <https://www.n0derunner.com/2018/09/hci-performance-testing-made-easy-part-3/>`_ - *Gary Little blog/video series on using X-Ray.*

Configuring Target Cluster Networks
+++++++++++++++++++++++++++++++++++

Log into **Prism Element** on the **3-node** cluster created in the previous lab (10.42.\ *XYZ*\ .37). This cluster will be used as an X-Ray target, meaning it will run worker VMs. It will **not** run the X-Ray VM.

Open **Prism > VM > Table** and click **Network Config**.

.. figure:: images/0.png

We will use the **Secondary** network VLAN for communication between the X-Ray VM and X-Ray worker VMs. This is accomplished via "Zero Configuration" networking, as the 3-node cluster **Secondary** and 1-node cluster **Secondary** networks are the same Layer 2 network and there is no DHCP.

Click **Virtual Networks > Create Network**.

Using the `Cluster Details`_ spreadsheet, fill out the following fields and click **Save**:

- **Name** - Secondary
- **VLAD ID** - *<Secondary VLAN ID>*

.. figure:: images/1.png

.. note::

   You can create the VLAN 0 network on this cluster as well, though it is not required for this exercise.

Creating X-Ray VM
+++++++++++++++++

Next you will deploy the X-Ray VM outside of your cluster targeted for testing. This is to ensure X-Ray tests that perform power operations on hosts don't inadvertently power off the X-Ray VM itself.

Log into **Prism Element** on your **1-node** cluster (10.42.\ *XYZ*\ .32).

In **Prism > VM > Table** and click **+ Create VM**.

Fill out the following fields and click **Save**:

- **Name** - XRay
- **vCPU(s)** - 2
- **Number of Cores per vCPU** - 1
- **Memory** - 4 GiB
- Select **+ Add New Disk**

  - **Operation** - Clone from Image Service
  - **Image** - X-Ray.qcow2
  - Select **Add**
- Select **Add New NIC**

  - **VLAN Name** - Primary
  - Select **Add**
- Select **+ Add New NIC**

  - **VLAN Name** - Secondary
  - Select **Add**

Select your **XRay** VM and click **Power on**.

The X-Ray VM is created with 2 NICs. The **Primary** NIC allows for access to the web interface from any other routable network, and the **Secondary** network is only for communication between X-Ray and its worker VMs deployed on target clusters.

.. note::

  At the time of writing, X-Ray 3.4 is the latest available version. The URL for the latest X-Ray OVA & QCOW2 images can be downloaded from the `Nutanix Portal <https://portal.nutanix.com/#/page/static/supportTools>`_.

Once the VM has started, click **Launch Console**.

Click **Applications > System Tools > Settings** in the upper-left hand corner of the X-Ray VM console.

.. figure:: images/2b.png

Under **Network**, select :fa:`cog` under **Ethernet (eth0)**.

.. note::

  It is critical that you select the network adapter assigned to the **Primary** network (you can confirm by comparing the MAC address in the VM console to the MAC address shown in Prism). We will use this network to assign a static IP to the X-Ray VM to access the web interface. We will NOT assign an address to the **Secondary** network adapter. This network will be used for zero configuration communication between the X-Ray VM and client VMs. This approach is helpful when DHCP isn't available or the DHCP scope isn't large enough to support X-Ray testing.

.. figure:: images/3.png

Select **IPv4**. Using the `Cluster Details`_ spreadsheet, fill out the following fields and click **Apply**:

- **IPv4 Method** - Manual
- **Address** - 10.42.\ *XYZ*\ .42
- **Netmask** - 255.255.255.128
- **Gateway** - 10.42.\ *XYZ*\ .1
- **DNS** - 10.42.196.10

.. figure:: images/4.png

Use the toggle switch to turn the **eth0** adapter off and back on to ensure the new IP is applied.

.. raw:: html

  <strong><font color="red">Close the X-Ray VM console.</font></strong>

Configuring X-Ray
+++++++++++++++++

Open \https://<*XRAY-VM-IP*>/ in a browser. Enter a password for the local secret score, such as your Prism cluster password, and click **Enter**.

.. figure:: images/7.png

Select **I have read and agree to the terms and conditions** and click **Accept**.

.. figure:: images/8.png

Click **My Nutanix Login** and specify your my.nutanix.com credentials. Fill out the following fields and click **Generate Token**:

- **Customer Name** - Nutanix Sales Enablement
- **Opportunity ID** - New Hire Training
- **Choose a reason for using X-Ray** - Self training on Nutanix

.. figure:: images/5.png

Click **Done**.

.. figure:: images/6.png

.. note::

  If deploying X-Ray in an environment without internet access, tokens can be generated at https://my.nutanix.com/#/page/xray.

Next you will configure your 3-node cluster as the target for running X-Ray tests.

Select **Targets** from the navigation bar and click **Add Target**. Fill out the following fields and click **Next**:

- **Name** - *<3-Node Cluster Name>*
- **Manager Type** - Prism
- **Power Management Type** - IPMI
- **Username** - ADMIN
- **Password** - ADMIN
- **Prism Address** - *<3-Node Cluster Virtual IP>*
- **Username** - admin
- **Password** - techX2019!

.. figure:: images/11.png

Select **Secondary** under **Network** and click **Next**.

.. figure:: images/12.png

This will provision any X-Ray worker VMs on the target cluster using our VLAN without DHCP for zero configuration networking between worker VMs and the X-Ray VM.

Select **Supermicro** from the **IPMI Type** menu. Review **Node Info** and click **Next**.

.. figure:: images/13.png

Click **Run Validation**.

.. figure:: images/14.png

Click **Check Details** to view validation progress.

.. figure:: images/15.png

Upon successful completion of validation, click **Done**.

.. figure:: images/16.png

Running X-Ray Tests
+++++++++++++++++++

While X-Ray offers many testing options that evaluate critical Day 2+ scenarios, for lack of time, we will utilize a simple microbenchmark test in this exercise.

Select **Tests** from the navigation bar and select **Four Corners Microbenchmark > View & Run Test**.

.. figure:: images/17.png

Review the test description, then select your **Test-Cluster** under **Choose test target** and click **Run Test**.

.. figure:: images/18.png

.. note::

  X-Ray can run one test per target at a time. Many tests can be queued for a single target, allowing X-Ray to automatically run through multiple tests without requiring manual intervention. Through automation, X-Ray can drastically decrease the amount of time to conduct a POC.

Select **Results** from the navigation bar and select the **In Progress** **Four Corners Microbenchmark** on your **Test-Cluster**.

Click **Running** under **Status** for additional details on the running test.

.. figure:: images/19.png

When the test reaches the **Run** phase (**Phase 3 of 4**), log into Prism on your 3-node cluster to monitor VM performance during the test.

.. figure:: images/20.png

.. note::

  High storage latency is expected during the "pre-filling" stage prior to running the target workloads as X-Ray worker VMs are writing sequential 1MB blocks to their disks to ensure the tests do not read only zeroes.

Upon completion of the test, select the **Finished Four Corners Microbenchmark** now located under **Results > All Results**.

.. figure:: images/21.png

The graphs are interactive, and you can click and drag to zoom into specific data/times on each individual graph. You can zoom out by clicking **Reset Zoom**.

Each dotted blue line represents an event in the test, such as beginning a workload, powering off a node, etc. Clicking the blue dots will provide information about the event.

Clicking the **Actions** drop down menu provides options to view the detailed log data, export the test results, and generate a PDF report.

Working with X-Ray Results
++++++++++++++++++++++++++

As X-Ray is using automation to perform the exact same tests and collect the same metrics on multiple systems/hypervisors, the results can be easily overlaid to compare solutions. In this exercise you will use X-Ray to compare BigData Ingestion test results between Nutanix and a competitor.

The BigData Ingestion test compares the speed at which 1TB of sequential data can be written to a single VM on a cluster, as is common in workloads such as Splunk.

Download the following exported X-Ray test results:

- :download:`Competitor Big Data Ingest Results<xray-big-data-competitor.zip>`
- :download:`Nutanix Big Data Ingest Results<xray-big-data-nutanix.zip>`

Select :fa:`cog` **> Import Test Results Bundle** from the navigation bar.

Click **Choose File** and select the Nutanix test results .zip file previously downloaded. Click **Upload**.

.. figure:: images/23.png

Repeat to import the Competitor test results .zip file.

Refresh the **Results** page and note **NTNX** and **Competitor-X** Big Data Ingestion test results now appear in the list as finished.

Select both tests and click **Create Comparison** to generate a comparison of the two sets of results.

.. figure:: images/24.png

Under **My Comparisons**, select the **Comparative Result Name** of your newly created comparison.

.. figure:: images/25.png

The resulting charts show the combined metrics for both solutions. In this case we can clearly see that the Nutanix solution is able to sustain a higher, and more consistent, rate of write throughput, resulting in a much faster time to complete ingesting the 1TB of data.

.. figure:: images/26.png

.. note::

  Can you explain **why** the Nutanix solution may produce better results than common HCI competitors?

  Hint! Check out the `OpLog <https://nutanixbible.com/#anchor-book-of-acropolis-i/o-path-and-cache>`_ section of the Nutanix Bible.

To export analysis results for use in proposal documents, etc., click **Actions > Create report**. Multiple analyses can also be selected to generate a combined report with the results from multiple tests, this can be extremely useful for summarizing POC results.
