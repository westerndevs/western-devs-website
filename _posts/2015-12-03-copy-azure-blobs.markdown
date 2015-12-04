---
layout: post
title:  Copy Azure Blobs
date: 2015-12-03T23:01:28-07:00
comments: true
author: simon_timms
---

Ever wanted to copy blobs from one Azure blob container to another? Me neither, until now. I had a bunch of files I wanted to use as part of a demo in a storage container and they needed to be moved over to a new container in a new resource group. It was 10 at night and I just wanted it solved so I briefly looked for a tool to do the copying for me. I failed to find anything. Ugh, time to write some 10pm style code, that is to say terrible code. Now you too can benefit from this. I put in some comments for fun.

{% highlight c# %}
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace migrateblobs
{
    class Program
    {
        static void Main(string[] args)
        {
			//this is the source account
            var sourceAccount = CloudStorageAccount.Parse("source connection string here");
            var sourceClient = sourceAccount.CreateCloudBlobClient();
            var sourceContainer = sourceClient.GetContainerReference("source container here");

            //destination account
            var destinationAccount = CloudStorageAccount.Parse("destination connection string here");
            var destinationClient = destinationAccount.CreateCloudBlobClient();
            var destinationContainer = destinationClient.GetContainerReference("destination container here");
			
			//create the container here
            destinationContainer.CreateIfNotExists();

            //this token is used so the destination client can pull from the source
            string blobToken = sourceContainer.GetSharedAccessSignature(
                       new SharedAccessBlobPolicy
                       {
                           SharedAccessExpiryTime =DateTime.UtcNow.AddYears(2),
                           Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write
                       });


            var srcBlobList = sourceContainer.ListBlobs(useFlatBlobListing: true, blobListingDetails: BlobListingDetails.None);
            foreach (var src in srcBlobList)
            {
                var srcBlob = src as CloudBlob;

                // Create appropriate destination blob type to match the source blob
                CloudBlob destBlob;
                if (srcBlob.Properties.BlobType == BlobType.BlockBlob)
                {
                    destBlob = destinationContainer.GetBlockBlobReference(srcBlob.Name);
                }
                else
                {
                    destBlob = destinationContainer.GetPageBlobReference(srcBlob.Name);
                }

                // copy using src blob as SAS
                destBlob.StartCopyFromBlob(new Uri(srcBlob.Uri.AbsoluteUri + blobToken));
            }
        }
    }
}
{% endhighlight %}

I stole some of this code from an old post [here](http://blogs.msdn.com/b/windowsazurestorage/archive/2012/06/12/introducing-asynchronous-cross-account-copy-blob.aspx) but the API has changed a bit since then so this article is a better reference. The copy operations take place asynchronously.

We're copying between containers without copying down the the local machine so you don't incur any egress costs unless you're moving between data centers. 

Have fun. 