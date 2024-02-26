import { curatedTagModel as model } from "@/store/curated_tag.store"
import { FETCH } from "@/store/model.store";

// this now does nothing on purpose because the backend is handling caps
// however if we ever need it it's still here
export const tagFormatter =  (tag) => {
  return tag;
  // if (!tag) return '';
  // return tag.split(' ').map(t => t[0].toUpperCase() + t.slice(1)).join(' ');
}

export const tagsMixin = {
  computed: {
    sessionTagsOptions() {
      return Object.values(this.$store.getters['jv/get']({ _jv: { type: model } }, '$[?(@.context=="tag")]')).map(t => ({ value: t.name, text: tagFormatter(t.name) }));
    },
    sessionLabelsOptions() {
      return Object.values(this.$store.getters['jv/get']({ _jv: { type: model } }, '$[?(@.context=="label")]')).map(t => ({ value: t.name, text: tagFormatter(t.name) }));
    }
  },
  methods: {
    tagFormatter,
    formatTags(tags) {
      return tags.length ? tags.map(tagFormatter).join(", ") : '';
    }
  },
  mounted() {
    this.$store.dispatch(FETCH, { model });
  }
}
