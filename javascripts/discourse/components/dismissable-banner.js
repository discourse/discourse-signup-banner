import Component from "@ember/component";
import { action } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import discourseComputed from "discourse-common/utils/decorators";

@tagName("")
export default class DismissableBanner extends Component {
  hidden = true;

  didInsertElement() {
    super.didInsertElement(...arguments);
    this.appEvents.on("cta:shown", this, this._triggerBanner);
  }

  willDestroyElement() {
    super.willDestroyElement(...arguments);
    this.appEvents.off("cta:shown", this, this._triggerBanner);
  }

  _triggerBanner() {
    this.set("hidden", false);
  }

  @discourseComputed("hidden")
  shouldShow(hidden) {
    return !hidden;
  }

  @action
  dismissBanner() {
    this.keyValueStore.setItem("anon-cta-never", "t");
    this.session.set("showSignupCta", false);
    this.set("hidden", true);
  }

  @action
  showBannerLater() {
    this.keyValueStore.setItem("anon-cta-hidden", Date.now());
    this.set("hidden", true);
  }
}
