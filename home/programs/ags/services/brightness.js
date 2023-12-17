import { Service, Utils } from "../imports.js";

const clamp = (num, min, max) => Math.min(Math.max(num, min), max);

class BrightnessService extends Service {
  static {
    Service.register(
      this,
      { "screen-changed": ["float"] },
      { "screen-value": ["float", "rw"] },
    );
  }

  #screenValue = 0;

  #interface = Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");
  #path = `/sys/class/backlight/${this.#interface}`;
  #brightness = `${this.#path}/brightness`;

  #max = Number(Utils.readFile(`${this.#path}/max_brightness`));

  get screen_value() {
    return this.#screenValue;
  }

  set screen_value(percent) {
    percent = clamp(percent, 0, 1);
    this.#screenValue = percent;

    Utils.writeFile(percent * this.#max, this.#brightness)
      .then(() => {
        this.emit("screen-changed", percent);
        this.notify("screen-value");
      })
      .catch(print);
  }

  constructor() {
    super();

    this.#updateScreenValue();
    Utils.monitorFile(this.#brightness, () => this.#onChange());
  }

  #updateScreenValue() {
    this.#screenValue = Number(Utils.readFile(this.#brightness)) / this.#max;
  }

  #onChange() {
    this.#updateScreenValue();

    this.notify("screen-value");
    this.emit("screen-changed", this.#screenValue);
  }

  connectWidget(widget, callback, event = "screen-changed") {
    super.connectWidget(widget, callback, event);
  }
}

const service = new BrightnessService();

// make it global for easy use with cli
globalThis.brightness = service;

export default service;
