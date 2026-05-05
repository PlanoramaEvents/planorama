import { mapGetters, mapState, mapActions } from 'vuex';
import toastMixin from '@/mixins/toast-mixin';
import { NEW_PAGE_CONTENT } from '@/store/page_content.store';
import { PAGE_CONTENT_SAVE_SUCCESS, PAGE_CONTENT_SAVE_ERROR, PAGE_CONTENT_SUCCESS_DELETE, PAGE_CONTENT_ERROR_DELETE } from '../constants/strings'
import modelUtilsMixin from '@/store/model_utils.mixin'
import { DELETE } from "@/store/model.store"

export const pageContentMixin = {
  mixins: [toastMixin, modelUtilsMixin],
  methods: {
    ...mapActions({
      new_page_content: NEW_PAGE_CONTENT
    }),
    newPageContent(newPageContent, success_text = PAGE_CONTENT_SAVE_SUCCESS, error_text = PAGE_CONTENT_SAVE_ERROR) {
      return this.toastPromise(
        this.new_page_content(newPageContent),
        success_text, error_text
      )
    },
    savePageContent(newPageContent, success_text = PAGE_CONTENT_SAVE_SUCCESS, error_text = PAGE_CONTENT_SAVE_ERROR) {
      return this.save_model('page_content', newPageContent)
    },
    deletePageContent(itemOrId, success_text = PAGE_CONTENT_SUCCESS_DELETE, error_text = PAGE_CONTENT_ERROR_DELETE) {
      return this.toastPromise(this.$store.dispatch(DELETE, { model: 'page_content', itemOrId: itemOrId }), success_text, error_text);
    }
  }
}

export default pageContentMixin;
