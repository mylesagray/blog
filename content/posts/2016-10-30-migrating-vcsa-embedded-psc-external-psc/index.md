---
title: Migrating from VCSA embedded PSC to external PSC
author: Myles Gray
type: posts
date: 2016-10-30T20:09:02+00:00
url: /virtualisation/migrating-vcsa-embedded-psc-external-psc/
resources:
- name: "featured-image"
  src: images/Screen-Shot-2016-10-30-at-19.36.44.png
categories:
  - Infrastructure
  - Virtualisation
tags:
  - psc
  - vcenter
  - vmware
---

On a bit of a shorter note to my previous article/novella<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_2683_89('footnote_plugin_reference_2683_89_1');" onkeypress="footnote_moveToReference_2683_89('footnote_plugin_reference_2683_89_1');" ><sup id="footnote_plugin_tooltip_2683_89_1" class="footnote_plugin_tooltip_text">1</sup></a><span id="footnote_plugin_tooltip_text_2683_89_1" class="footnote_tooltip"><a href="https://blah.cloud/architecture/designing-modern-private-cloud-network/"><span class="footnote_url_wrap">https://blah.cloud/architecture/designing-modern-private-cloud-network/</span></a></span></span> - I have been moving my lab to a bit more of an "enterprise" style architecture - deploying SRM was in the way for that, so I had the need to set up another vCenter, however this gave the opportunity to move to a multi-PSC, multi-VC architecture.

There is quite some complexity in my lab with regard to vCenter and its integrations, I have running in production vRO, NSX and vCD - it's also plugged into VIO and VR, so naturally I _really_ don't want to reinstall all these components and reconfigure them as a lot of work has gone in, in particular with NSX, dynamic peering etc set up with upstream routers and its integration with vCD.

I found a great KB<span class="footnote_referrer"><a role="button" tabindex="0" onclick="footnote_moveToReference_2683_89('footnote_plugin_reference_2683_89_2');" onkeypress="footnote_moveToReference_2683_89('footnote_plugin_reference_2683_89_2');" ><sup id="footnote_plugin_tooltip_2683_89_2" class="footnote_plugin_tooltip_text">2</sup></a><span id="footnote_plugin_tooltip_text_2683_89_2" class="footnote_tooltip"><a href="http://blogs.vmware.com/vsphere/2015/10/reconfiguring-and-repointing-deployment-models-in-vcenter-server-6-0-update-1.html?src=vmw_so_vex_mgray_1080"><span class="footnote_url_wrap">http://blogs.vmware.com/vsphere/2015/10/reconfiguring-and-repointing-deployment-models-in-vcenter-server-6-0-update-1.html?src=vmw_so_vex_mgray_1080</span></a></span></span> for such a migration from a vCenter with an embedded PSC to one with an external PSC.

So, my current setup:

<p align="center">
  ![""](images/Screen-Shot-2016-10-30-at-15.53.47.png)
</p>

And the final goal (this will likely expand to multiple PSCs in future):

<p align="center">
  ![""](images/Screen-Shot-2016-10-30-at-16.00.25.png)
</p>

The first step is to deploy an external PSC only and link it to the already existing vC with embedded PSC, so download the VCSA install ISO, choose install then deploy to your existing vCenter server (in my case: `vc01.lab.mylesgray.io`) - Choose `Install Platform Services Controller`:

![Install Platform Services Controller][1] 

Then you want to join it to the existing SSO domain:

![Join existing SSO domain][2] 

Then choose to add to the existing SSO site:

![Join PSC to existing site][3] 

Go ahead and deploy the rest of the PSC through the wizard and confirm it comes up okay in your existing vCenter:

![PSC up in vCenter][4] 

Now the fun part, we need to log into the existing vCenter with SSH and reconfigure SSO to point to the new external PSC. I've filled out the below command with the params relevant to my environment:

    vc01:~ # cmsso-util reconfigure --repoint-psc psc01.lab.mylesgray.io --username administrator --domain-name vsphere.local --passwd MySSOPasswordHere
    Validating Provided Configuration ...
    Validation Completed Successfully.
    Executing reconfiguring steps. This will take few minutes to complete.
    Please wait ...
    Stopping all the services ...
    All services stopped.
    Starting vmafd service.
    Successfully joined the external PSC psc01.lab.mylesgray.io
    Cleaning up...
    Cleanup completed
    Starting all the services ...
    Started all the services.
    The vCenter Server has been successfully reconfigured and repointed to the external Platform Services Controller psc01.lab.mylesgray.io.
    

Next we should verify that it reconfigured correctly:

    vc01:~ # /usr/lib/vmware-vmafd/bin/vmafd-cli get-ls-location --server-name localhost
    https://psc01.lab.mylesgray.io:443/lookupservice/sdk
    

You will need to join the PSC to AD again if your vC was previous AD joined to maintain any windows based SSO you may have had as identity services have obviously moved to the PSC now. This can be found at:

`Home -> Administration -> System Configuration -> Nodes -> [Choose your PSC] -> Manage -> Settings -> Active Directory -> Join...`

![PSC AD Join Screen][5] 

Once joined to your AD again, reboot the PSC and your permissions will be restored across all VC objects.

Now we can go ahead and install our second vCenter server, jump into the VCSA install process again but this time choose to deploy a vCenter Server with external PSC:

![Deploy vCenter server external PSC][6] 

Then we need to fill in our newly deployed PSC's FQDN, SSO user and password then carry on through the install process.

![vc02 platform services controller install][7] 

Deployment can take a while depending on your storage. Once the second VC comes up, it should show up in your primary VC server under the following directory:

`Home -> Administration -> System Configuration -> Nodes`

![VC nodes and PSCs][8] 

If you can log into both VCs with integrated windows SSO, you know you've done a good job, oh and when you see this:

![Two VCs][9] 

**Please note:** any configurations that directly reference the SSO lookup url will need changed to the new PSC FQDN - NSX and VR are examples of such.

Any questions, drop me a line below, until next time!

Why not follow [@mylesagray on Twitter][10] for more like this!

<div class="speaker-mute footnotes_reference_container">
  <div class="footnote_container_prepare">
    <p>
      <span role="button" tabindex="0" class="footnote_reference_container_label pointer" onclick="footnote_expand_collapse_reference_container_2683_89();">References</span><span role="button" tabindex="0" class="footnote_reference_container_collapse_button" style="display: none;" onclick="footnote_expand_collapse_reference_container_2683_89();">[<a id="footnote_reference_container_collapse_button_2683_89">+</a>]</span>
    </p>
  </div>
  
  <div id="footnote_references_container_2683_89" style="">
    <table class="footnotes_table footnote-reference-container">
      <caption class="accessibility">References</caption> <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_2683_89('footnote_plugin_tooltip_2683_89_1');">
          <a id="footnote_plugin_reference_2683_89_1" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>1</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="https://blah.cloud/architecture/designing-modern-private-cloud-network/"><span class="footnote_url_wrap">https://blah.cloud/architecture/designing-modern-private-cloud-network/</span></a>
        </td>
      </tr>
      
      <tr class="footnotes_plugin_reference_row">
        <th scope="row" class="footnote_plugin_index_combi pointer"  onclick="footnote_moveToAnchor_2683_89('footnote_plugin_tooltip_2683_89_2');">
          <a id="footnote_plugin_reference_2683_89_2" class="footnote_backlink"><span class="footnote_index_arrow">&#8593;</span>2</a>
        </th>
        
        <td class="footnote_plugin_text">
          <a href="http://blogs.vmware.com/vsphere/2015/10/reconfiguring-and-repointing-deployment-models-in-vcenter-server-6-0-update-1.html?src=vmw_so_vex_mgray_1080"><span class="footnote_url_wrap">http://blogs.vmware.com/vsphere/2015/10/reconfiguring-and-repointing-deployment-models-in-vcenter-server-6-0-update-1.html?src=vmw_so_vex_mgray_1080</span></a>
        </td>
      </tr>
    </table>
  </div>
</div>

 [1]: images/Screen-Shot-2016-10-30-at-16.03.04.png
 [2]: images/Screen-Shot-2016-10-30-at-16.03.23.png
 [3]: images/Screen-Shot-2016-10-30-at-16.08.41.png
 [4]: images/Screen-Shot-2016-10-30-at-16.22.10.png
 [5]: images/Screen-Shot-2016-10-30-at-18.24.31.png
 [6]: images/Screen-Shot-2016-10-30-at-18.22.40.png
 [7]: images/Screen-Shot-2016-10-30-at-18.22.56.png
 [8]: images/Screen-Shot-2016-10-30-at-19.36.44.png
 [9]: images/Screen-Shot-2016-10-30-at-19.54.09.png
 [10]: https://twitter.com/mylesagray