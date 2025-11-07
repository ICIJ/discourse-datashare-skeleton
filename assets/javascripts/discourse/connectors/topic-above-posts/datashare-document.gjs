import Component from "@ember/component";
import DatashareDocumentCard from "../../components/datashare-document-card";

/**
 * This connector renders add Datashare document card component above the
 * list of posts in a topic.
 */
export default class DatashareDocumentConnector extends Component {  
  get shouldRender() {
    // Only document's with an URL and a title are valid
    return !!(this.datashareDocument.url && this.datashareDocument.title);
  }

  get datashareDocument() {
    return this.model.datashare_document;
  }
  
  <template>
    {{#if this.shouldRender}}
      <DatashareDocumentCard
        @title={{this.datashareDocument.title}}
        @url={{this.datashareDocument.url}}
        @contentType={{this.datashareDocument.contentType}}
      />
    {{/if}}
  </template>
}
