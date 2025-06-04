import Component from "@ember/component";
import { action } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import DButton from "discourse/components/d-button";
import routeAction from "discourse/helpers/route-action";
import discourseComputed from "discourse/lib/decorators";

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

  <template>
    {{#if this.shouldShow}}
      <div class="discourse-signup-banner">
        <div class="discourse-signup-banner-content">
          <h1 class="discourse-signup-banner-content-header">
            {{settings.heading_text}}
          </h1>
          <p class="discourse-signup-banner-content-text">
            {{settings.subheading_text}}
          </p>
        </div>
        <div class="discourse-signup-banner-cta">
          <div class="discourse-signup-banner-cta-signup">
            <DButton
              @action={{routeAction "showCreateAccount"}}
              class="btn-primary sign-up-button"
              @translatedLabel={{settings.signup_text}}
            />
          </div>
          <div class="discourse-signup-banner-cta-actions">
            <DButton
              @action="showBannerLater"
              @translatedLabel={{settings.reminder_text}}
            />
            <DButton
              @action="dismissBanner"
              @translatedLabel={{settings.dismiss_text}}
            />
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
