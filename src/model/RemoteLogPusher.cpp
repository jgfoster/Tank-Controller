#include "model/RemoteLogPusher.h"

RemoteLogPusher* RemoteLogPusher::instance() {
  if (!_instance) {
    _instance = new RemoteLogPusher();
  }
  return _instance;
}

void RemoteLogPusher::loop() {
  // This function does nothing in the current codebase
}

void RemoteLogPusher::pushSoon() {
  // This function does nothing in the current codebase
}