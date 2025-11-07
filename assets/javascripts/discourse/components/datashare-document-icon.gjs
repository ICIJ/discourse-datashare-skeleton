import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import icon from "discourse/helpers/d-icon";


export default class DatashareDocumentCard extends Component {
  get contentTypeIcon() {
    if (this.args.contentType) {
      const type = this.args.contentType.toLowerCase();
      if (type.includes("pdf")) {
        return "file-pdf";
      }
      if (type.includes("word") || type.includes("msword")) {
        return "file-word";
      }
      if (type.includes("excel") || type.includes("spreadsheet")) {
        return "file-excel";
      }
      if (type.includes("powerpoint")) {
        return "file-powerpoint";
      }
      if (type.includes("image")) {
        return "file-image";
      }
      if (type.includes("video")) {
        return "file-video";
      }
      if (type.includes("audio")) {
        return "file-audio";
      }
      if (type.includes("zip") || type.includes("compressed")) {
        return "file-zipper";
      }
    }
    return "file";
  }

  <template>
    {{icon this.contentTypeIcon}}
  </template>
}
