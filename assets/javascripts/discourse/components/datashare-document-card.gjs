import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import icon from "discourse/helpers/d-icon";
import DatashareDocumentIcon from "./datashare-document-icon";

export default class DatashareDocumentCard extends Component {
  get safeUrl() {
    return htmlSafe(this.args.url);
  }

  <template>
    <div class="datashare-document-card">
      <div class="datashare-document-card__icon">
        <DatashareDocumentIcon @contentType={{@contentType}} />
      </div>
      <a
        class="datashare-document-card__link"
        href={{this.safeUrl}}
        target="_blank" rel="noopener noreferrer"
      >
        {{@title}}
        {{icon
          "arrow-up-right-from-square"
          class="datashare-document-card__link__icon"
        }}
      </a>
    </div>
  </template>
}
