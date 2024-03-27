import Component from "@ember/component";
import { action } from "@ember/object";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  tagName: "",
  hidden: true,

  didInsertElement() {
    this._super(...arguments);
    this.appEvents.on("cta:shown", this, this._triggerBanner);
  },

  willDestroyElement() {
    this._super(...arguments);
    this.appEvents.off("cta:shown", this, this._triggerBanner);
  },

  _triggerBanner() {
    this.set("hidden", false);
  },

  @discourseComputed("hidden")
  shouldShow(hidden) {
    return !hidden;
  },

  @action
  dismissBanner() {
    this.keyValueStore.setItem("anon-cta-never", "t");
    this.session.set("showSignupCta", false);
    this.set("hidden", true);
  },

  @action
  showBannerLater() {
    this.keyValueStore.setItem("anon-cta-hidden", Date.now());
    this.set("hidden", true);
  },
});
