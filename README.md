# Bash script for port scanning multiple IPs

This is a Bash script that allows you to perform port scanning for multiple IP addresses specified in a file.

The script uses `/dev/tcp` to attempt to connect to the specified IP address and port number. If the connection is successful, the script will print a message indicating that the port is open.

## Requirements

This script requires Bash version 4 or later to run. It has been tested on macOS and Linux, but it should work on any platform that supports Bash.

## Usage

The script can be run with the following command:

```bash
$ ./port_scan.sh [-t num_threads] [-i num_ips] <filename>
```

where:

- `-t num_threads` specifies the number of threads to use for port scanning. By default, the script uses a single thread.
- `-i num_ips` specifies the number of IP addresses to scan in parallel. By default, the script scans one IP address at a time.
- `<filename>` is the name of the file that contains the list of IP addresses to scan.

The script will scan the first 10,000 ports for each IP address in the file. If a port is open, the script will print a message indicating that the port is open in green color.

## Example

To scan the ports for multiple IP addresses with 4 threads and 2 IPs in parallel, run the following command:
```bash
$ ./port_scan.sh -t 4 -i 2 ips.txt
```

where `ips.txt` is a file that contains a list of IP addresses, one per line.

## Notes

- The script checks if each IP address in the file is valid before attempting to scan its ports. If an invalid IP address is found, the script will print an error message.
- The script uses a timeout of 1 second for each connection attempt to prevent it from hanging on closed ports. If a connection cannot be established within 1 second, the script will assume that the port is closed.
- The script prints the IP address in yellow bold color before scanning its ports.
