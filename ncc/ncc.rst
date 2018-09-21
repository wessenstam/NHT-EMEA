.. _groupncc_lab:

-------------
Support Tools
-------------

Overview
++++++++

.. note::

  Estimated time to complete: **15 Minutes**

In this exercise you will use some of the common tools that can accelerate resolution of support cases: Nutanix Cluster Check (NCC), Log Collector, and collect_perf.

Cluster Details
...............

Using the spreadsheet below, locate your **Group Number** and corresponding details for your group's assigned cluster.

.. raw:: html

  <iframe src=https://docs.google.com/spreadsheets/d/e/2PACX-1vQyI5rZlI4OQ5KbbUmEYXYRKb7zHvmFGQlqBmFqynNc4BNNlzBvgUamtfIdy2AlGLZYektSupV1_72a/pubhtml?gid=0&amp;single=false&amp;widget=false&amp;chrome=false&amp;headers=false&amp;range=a1:m41 style="position: relative; height: 500px; width: 100%; border: none"></iframe>

References
..........

- `Nutanix Cluster Check (NCC) 3.6 Guide <https://portal.nutanix.com/#/page/docs/details?targetId=NCC-Guide-NCC-v36:NCC-Guide-NCC-v36>`_
- `Acropolis Command Reference > Controller VM Commands > ncc <https://portal.nutanix.com/#/page/docs/details?targetId=Command-Ref-AOS-v58:aut-ncc-crg-auto-r.html>`_
- `KB1406 Log Collector Usage <https://portal.nutanix.com/#/page/kbs/details?targetId=kA0600000008cPfCAI>`_
- `KB1993 How to use collect_perf to capture performance data <https://portal.nutanix.com/#/page/kbs/details?targetId=kA0600000008hQVCAY>`_

Additional Resources
....................

- `SRE Bootcamp Training Materials <https://confluence.eng.nutanix.com:8443/pages/viewpage.action?spaceKey=~stephan.mercato&title=%5BBootcamp%5D+-+Acropolis+Architecture>`_ - *Great supplemental Nutanix architecture information*
- `SRE Technical Communities Wiki <https://confluence.eng.nutanix.com:8443/display/STK/Technical+Communities>`_ - *Support documentation on Hypervisors, Core AOS, Core Data Path, Performance, Prism, Tools, and Emerging Technologies.*

NCC
+++

**What is NCC?**

*Nutanix Cluster Check (NCC) is a framework of scripts that can help diagnose cluster health. NCC can be run provided that the individual nodes are up, regardless of cluster state. The health checks collect critical information regarding anomalies, Cassandra, data protection, hardware, hypervisor, network, Stargate, and more.*

**When would I run NCC?**

*As an SE, you would typically run NCC after a POC installation to ensure there are no immediate issues with the cluster, such as a misconfigured NTP server. Additionally, NCC should be run and the results attached to support cases. Providing this information proactively to support can often drastically reduce troubleshooting time.*

*All default checks are non-intrusive and can be run without concern for impacting the cluster.*

**You down with NCC?**

*Yeah you know me!*

------------

Log into **Prism** on your 3-node **POC** cluster (10.21.\ *XYZ*\ .37).

Open **Prism > Health** and click **Actions > Run Checks**.

.. figure:: images/1.png

.. note::

  NCC can also be configured to run every 4 hours, daily, or weekly and the results will be e-mailed to all **E-mail Recipients** defined in **Alert E-mail Configuration** in cluster settings.

Select **All Checks**. De-select **Send the cluster check report in the email**. Click **Run**.

.. figure:: images/2.png

Select **Prism > Tasks** and wait for the **Health check** to reach 100%.

.. figure:: images/3.png

Click **Succeeded** under Status to view the report summary. Click **Download Output** for the details of any non-Passed tests.

.. figure:: images/4.png

Review the output and note specific KB articles are cited for common issues.

.. literalinclude:: ncc-output-example.txt
   :caption: Example NCC Output

The **ncc-output-YYYY-MM-DD-TIME.txt** file is what should be attached to new support cases.

.. note::

  NCC can also be run from the command line by connecting to any CVM via SSH and executing the following command:

  ``nutanix@CVM$ ncc health_checks run_all``

  Refer to `Nutanix Cluster Check (NCC) 3.6 Guide <https://portal.nutanix.com/#/page/docs/details?targetId=NCC-Guide-NCC-v36:NCC-Guide-NCC-v36>`_ for complete details on command line execution.

Log Collector
+++++++++++++

**What is Log Collector?**

*Log Collector is an NCC plugin used to bundle logs present on the CVM. By default, all levels of logs are collected (INFO, ERROR, WARNING, FATAL). Refer to `KB1406 <https://portal.nutanix.com/#/page/kbs/details?targetId=kA0600000008cPfCAI>`_ for complete details on all services, alerts, and cluster configuration details collected.*

**When would I run Log Collector?**

*Log Collector bundles are critical for any offline analysis of a Support Case or Engineering ONCALL Case.*

*Log Collector is a resource intensive task. Running it for a long period might cause performance degradation on the Controller VM where you are running the Log Collector. Use caution if business needs require peak performance levels. In this case, run the Log Collector during a maintenance window if possible.*

*All logs gathered should be uploaded to the Support Case via https://portal.nutanix.com.*

------------

Log into **Prism** on your 3-node **POC** cluster (10.21.\ *XYZ*\ .37).

Open **Prism > Health** and click **Actions > Log Collector**.

.. figure:: images/1.png

Select **Collect Logs starting now** and use the default collection period of 4 hours. Click **Run Now**.

.. note::

  Logs can also be collected from a custom date/time range, for example, if an issue occurred during the middle of the night but troubleshooting didn't begin until the following day. Logs can be collected covering a time period of 4 to 24 hours.

Select **Prism > Tasks** and wait for the **Log collector** to reach 100%.

.. figure:: images/6.png

Click **Succeeded** under Status to download the **NCC-logs-YYYY-MM-DD-TIME.tar** file.

.. note::

  By default, Log Collector does not anonymize (obscure) output for fields such as e-mail addresses, IP addresses, cluster name, etc.

  To obtain a Log Collector bundle with anonymized data, connect to any CVM via SSH and executing the following command:

  ``nutanix@CVM$ ncc log_collector --anonymize_output=True``

  Refer to `KB1406 <https://portal.nutanix.com/#/page/kbs/details?targetId=kA0600000008cPfCAI>`_ for complete details command line execution.

collect_perf
++++++++++++

**What is collect_perf?**

*collect_perf is a utility used to capture performance data from a Nutanix cluster.*

**When would I run Log Collector?**

*collect_perf would typically only be run under the guidance of Support or Performance Engineering in supporting a performance issue. This exercise is more about awareness.*

*After gathering information on the specific performance issue from the customer and reviewing the relevant performance data available in the Prism Analysis page, if the issue cannot be resolved by live troubleshooting, or if the issue is not immediately reproducible, you can gather performance data by using the collect_perf utility.*

*It is critical that you collect data that covers a time when a given customer complaint is being experienced.  Ensure that you work with the cluster administrator to define when the utility will be started and stopped and have them provide information on what occurred during the window.*

*The collect_perf is generally safe to run, however in some circumstances it may be desirable to reduce the dataset collected to reduce overhead. Significant CPU consumers such as activity traces and vdisk stats may need to be excluded in such cases where CPU usage may already be high on a given CVM and/or its corresponding host.*

------------

Using an SSH client (e.g. PuTTY, Terminal) connect to nutanix@10.21.\ *XYZ*\ .37.

To start collecting performance stats, execute the following:

``nutanix@CVM$ collect_perf start``

.. note::

  By default, collect_perf will only allow the output file to grow to 20% of available capacity on the CVM from which it is being run. This is why it's important to define the window during which the performance degrading event is expected to occur.

  The CVM's `crontab <https://en.wikipedia.org/wiki/Cron>`_ can be leveraged to start and stop collect_perf at pre-determined times.

To verify collection is running, execute the following:

``nutanix@CVM$ tail data/performance/run/collect_perf.log``

After the desired event has been captured, stop collect_perf by executing the following:

``nutanix@CVM$ collect_perf stop``

.. note::

  It can take up to 20 minutes to stop the collect_perf process.

After data collection has stopped, the output .tgz file will be available in /home/nutanix/data/performance.

------------

**So what does support do with these things?**

*Performance cases do not always fall into a typical "break-fix" category, and are often complex in nature. Additionally, analyzing performance data collected for these cases can be time consuming, and complicated. Performance data bundles are first uploaded to an internal server called `Illuminati <http://illuminati.corp.nutanix.com>`_ where the data will be automatically checked for common performance issues.*

.. figure:: images/7.png

*The resulting report, called the Weather Report, provides key details regarding CPU usage, Oplog usage, Medusa (metadata) latency, and cold tier (HDD) reads to can be used to pinpoint the cause of a given performance issue.*

.. figure:: images/8.png
