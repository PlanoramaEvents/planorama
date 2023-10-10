import { mapGetters, mapState, mapActions } from 'vuex';
import toastMixin from '../shared/toast-mixin';
import { NEW_PAGE_CONTENT } from '@/store/page_content.store';
import { PAGE_CONTENT_SAVE_SUCCESS, PAGE_CONTENT_SAVE_ERROR } from '../constants/strings'
import modelUtilsMixin from '../store/model_utils.mixin'

export const pageContentMixin = {
  mixins: [toastMixin, modelUtilsMixin],
  methods: {
    ...mapActions({
      new_page_content: NEW_PAGE_CONTENT
    }),
    savePageContent(newPageContent, success_text = PAGE_CONTENT_SAVE_SUCCESS, error_text = PAGE_CONTENT_SAVE_ERROR) {
      if (newPageContent.id) {
        return this.save_model('page_content', newPageContent)
      } else {
        return this.toastPromise(
          this.new_page_content(newPageContent),
          success_text, error_text
        )
      }
    },
  }
}

export default pageContentMixin;
