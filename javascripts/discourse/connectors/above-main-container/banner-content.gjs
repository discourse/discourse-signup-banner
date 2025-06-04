import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import DismissableBanner from "../../components/dismissable-banner";

@classNames("above-main-container-outlet", "banner-content")
export default class BannerContent extends Component {
  <template><DismissableBanner /></template>
}
