/**
 * source: https://opensource.com/article/19/4/interprocess-communication-linux-storage
 */

#include <chrono>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <unistd.h>

namespace shared_file {

static const std::chrono::time_point<std::chrono::system_clock> START_TIME =
    std::chrono::system_clock::now();

inline unsigned long get_current_time() {
  auto micros_ = std::chrono::duration_cast<std::chrono::microseconds>(
                     std::chrono::system_clock::now() - START_TIME)
                     .count();
  return static_cast<unsigned long>(micros_);
}

void report_and_exit(const char *msg) {
  perror(msg);
  exit(-1); /* EXIT_FAILURE */
}

class SharedFileIPC {
protected:
  const std::string file_name_;
  struct flock lock;
  int fd;
  int c;

public:
  SharedFileIPC(const std::string &name, int flags) : file_name_(name), fd(-1) {
    fd = open(file_name_.c_str(), flags, 0666);
    if (fd < 0) {
      report_and_exit("open failed...");
    }
  }

  void end() { close(fd); }
};

class SharedFileIPCWriter : public SharedFileIPC {
private:
  std::string clear_msg = "\n";

public:
  SharedFileIPCWriter(const std::string &name)
      : SharedFileIPC(name, O_RDWR | O_CREAT | O_TRUNC) {

    lock.l_type = F_WRLCK;    /* read/write (exclusive versus shared) lock */
    lock.l_whence = SEEK_SET; /* base for seek offsets */
    lock.l_start = 0;         /* 1st byte in file */
    lock.l_len = 0;           /* 0 here means 'until EOF' */
    lock.l_pid = getpid();    /* process id */
  }

  void write_to_file(const std::string &msg) {
    if (fcntl(fd, F_SETLKW, &lock) < 0) {
      report_and_exit("fcntl failed to get lock...");
    }
    if (ftruncate(fd, 0) == -1)
      perror("Could not truncate");
    write(fd, msg.c_str(), msg.size()); /* populate data file */
    fprintf(stderr, "Process %d has written to data file... %s", lock.l_pid,
            msg.c_str());
    /* Now release the lock explicitly. */
    lock.l_type = F_UNLCK;
    if (fcntl(fd, F_SETLK, &lock) < 0)
      report_and_exit("explicit unlocking failed...");
  }
};

class SharedFileIPCReader : public SharedFileIPC {
private:
public:
  SharedFileIPCReader(const std::string &name) : SharedFileIPC(name, O_RDONLY) {
    lock.l_type = F_WRLCK;    /* read/write (exclusive) lock */
    lock.l_whence = SEEK_SET; /* base for seek offsets */
    lock.l_start = 0;         /* 1st byte in file */
    lock.l_len = 0;           /* 0 here means 'until EOF' */
    lock.l_pid = getpid();    /* process id */
  }

  void read_from_file() {

    /* If the file is write-locked, we can't continue. */
    /* sets lock.l_type to F_UNLCK if no write lock */
    fcntl(fd, F_GETLK, &lock);
    if (lock.l_type != F_UNLCK)
      report_and_exit("file is still write locked...");

    lock.l_type = F_RDLCK; /* prevents any writing during the reading */
    if (fcntl(fd, F_SETLK, &lock) < 0)
      report_and_exit("can't get a read-only lock...");

    /* Read the bytes (they happen to be ASCII codes) one at a time. */
    /* buffer for read bytes */
    while (read(fd, &c, 1) > 0)    /* 0 signals EOF */
      write(STDOUT_FILENO, &c, 1); /* write one byte to the standard output */

    /* Release the lock explicitly. */
    lock.l_type = F_UNLCK;
    if (fcntl(fd, F_SETLK, &lock) < 0)
      report_and_exit("explicit unlocking failed...");
  }
};

} // namespace shared_file


/** publisher.cpp */
// #include "shf.hpp"
// #include <iostream>

// int main() {

//   shared_file::SharedFileIPCWriter writer("/tmp/shared_file");
//   std::string msg;
//   unsigned long start_time_ = shared_file::get_current_time();
//   while (true) {
//     auto t = (shared_file::get_current_time() - start_time_) * 1e-6f;
//     msg = "Publisher@" + std::to_string(t) + "\n";
//     writer.write_to_file(msg);
//     sleep(1);
//   }

//   return 0;
// }

/** subscriber.cpp */
// #include "shf.hpp"
// #include <iostream>

// int main() {

//   shared_file::SharedFileIPCReader reader("/tmp/shared_file");

//   unsigned long start_time_ = shared_file::get_current_time();
//   while (true) {
//     reader.read_from_file();
//     sleep(1);
//   }

//   return 0;
// }

