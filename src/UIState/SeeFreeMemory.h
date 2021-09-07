#pragma once
#include "UIState.h"

class SeeFreeMemory : public UIState {
public:
  SeeFreeMemory(TankController* tc) : UIState(tc) {
  }
  void start();
  const __FlashStringHelper* name() {
    return F("SeeFreeMemory");
  }
  const __FlashStringHelper* prompt() {
    return F("Free Memory:");
  };
};