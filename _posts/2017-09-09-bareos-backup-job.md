---
layout: post
title: Arch Linux Infrastructure - NAS - Part 7.5 - Bareos Backup Job
---

Create a backup job on Bareos

```
nano /etc/bareos/bareos-dir.d/schedule/Nightly.conf
```

```
Schedule {
  # name (required)
  Name = "Nightly"
  
  # run time
  # allot of options are available,
  # you can create multiple "Run =" times
  # for now lets keep it simple
  # this will run once a day, every day at 21:10
  Run = daily at 21:10
}
```

```
chown bareos.bareos Nightly.conf
```

Fileset

Next we need to let bareos know what we want to have backed up, by default one of the filesets is already useful for Linux : LinuxAll. This fileset will backup all the root and all its subdirectory’s. This however is way to much and for our storage servers would simply not be possible. So let’s go ahead and create a new file :

```
nano /etc/bareos/bareos-dir.d/fileset/LinuxConfig.conf
```

```
FileSet {
  # name (required)
  Name = "LinuxConfig"
  # include directory
  Include {
    Options {
      # calculate a signature for all files
      # both MD5/SHA1 are available, this is definitly for long term storage
      # a good idea to activate, note that the hash ads a bit of storage overhead
      Signature = MD5
      
      # compress every file with compression software
      # best known are : LZ4/GZIP (see manual for the others)
      # LZ4 is super fast in both compression and decompression
      # I would activate this always.
      Compression = LZ4
      
      # if supported by the OS, the read time won't be adapted
      # this would generate a bunch of writes for no reason on the client machine.
      noatime = yes
    }
    # the directory we are including
    # note: no trailing slashes!
    File = /etc
  }
}
```

Jobdefs

```
nano /etc/bareos/bareos-dir.d/jobdef/BackupLinuxConfig.conf
```

```
JobDefs {
  # name (required)
  Name = "BackupLinuxConfig"
  
  # type can be backup/restore/verify
  Type = Backup
  
  # the default level bareos will try
  # can also be Full/Differential(since last full)/Incremental(since last incremental)
  Level = Incremental
  
  # the default client, to be overwritten by the job.conf
  Client = bareos-fd
  
  # what files to include/exclude
  FileSet = "LinuxConfig"
  
  # the schedule we just created
  Schedule = "Nightly"
  
  # where to store it
  Storage = File
  
  # the message reporting
  Messages = Standard
  
  # the pool where to store it
  Pool = Incremental
  
  # the higher the value priority the lower it will be dropped in the queue
  # so for important jobs priority=1 will run first
  Priority = 10
  
  # the bootstrap file keeps a "log" of all the backups, and gets rewritten every time a 
  # full backup is made, it can be used during recovery
  Write Bootstrap = "/var/lib/bareos/%c.bsr"
  
  # in case these value's get overwritten
  # define where would be a good pool to write 
  # note that full backup will be used atleast once because no full
  # backup will exist
  Full Backup Pool = Full
  Differential Backup Pool = Differential
  Incremental Backup Pool = Incremental
}
```

Job

```
nano /etc/bareos/bareos-dir.d/job/rockstor-etc-backup.conf
```

```
Job {
  # required
  Name = "rockstor-etc-backup"
  
  # the default settings
  JobDefs = "BackupLinuxConfig"
  
  # overwrite the client here
  Client = "bareos-fd"
}
```

Running the job

The job will start every day at 21:10, but as a test, just start to run it now. Before you can start, be sure to check that all files you created are owned by bareos user if not.

```
chown -R bareos:bareos /etc/bareos
```

Go to the bconsole and reload the configuration, this is required.

```
bconsole
```

Output

```
*
```


Run reload.

```
*reload
```

Output

```
reloaded
```

Run the backup job created above.

```
* run job=rockstor-etc-backup
```

Output

```
Using Catalog "MyCatalog"
Run Backup job
JobName:  rockstor-etc-backup
Level:    Incremental
Client:   bareos-fd
Format:   Native
FileSet:  LinuxConfig
Pool:     Incremental (From Job IncPool override)
Storage:  File (From Job resource)
When:     2017-09-10 03:44:12
Priority: 10
OK to run? (yes/mod/no): yes
Job queued. JobId=15
You have messages.
```

```
*messages
```

Output

```
10-Sep 03:45 bareos-dir JobId 15: No prior Full backup Job record found.
10-Sep 03:45 bareos-dir JobId 15: No prior or suitable Full backup found in catalog. Doing FULL backup.
10-Sep 03:45 bareos-dir JobId 15: Start Backup JobId 15, Job=rockstor-etc-backup.2017-09-10_03.44.21_22
10-Sep 03:45 bareos-dir JobId 15: Using Device "FileStorage" to write.
10-Sep 03:45 bareos-sd JobId 15: Volume "Full-0001" previously written, moving to end of data.
10-Sep 03:45 bareos-sd JobId 15: Ready to append to end of Volume "Full-0001" size=57999502
*
```

**Note:** *You can just do a “run” and you will be prompted for the job you wish to run.*

The first backup will be a "full" one, and the next one should be "incremental". Run the job a few times to check it out.

Login in to the web interface, the job we ran will appear under jobs.
