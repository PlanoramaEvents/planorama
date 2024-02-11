import { curatedTagModel as model } from "@/store/curated_tag.store"
import { FETCH } from "@/store/model.store";

export const tagFormatter =  (tag) => {
  if (!tag) return '';
  return tag.split(' ').map(t => t[0].toUpperCase() + t.slice(1)).join(' ');
}

export const tagsMixin = {
  computed: {
    sessionTagsOptions() {
      return Object.values(this.$store.getters['jv/get']({ _jv: { type: model } }, '$[?(@.context=="tag")]')).map(t => ({ text: tagFormatter(t.name), value: t }));
    },
    sessionLabelsOptions() {
      return Object.values(this.$store.getters['jv/get']({ _jv: { type: model } }, '$[?(@.context=="label")]')).map(t => ({ text: tagFormatter(t.name), value: t }));
    }
  },
  methods: {
    tagFormatter,
    formatTags(tags) {
      return tags.length ? tags.map(tagFormatter).join(", ") : 'None'
    }
  },
  mounted() {
    this.$store.dispatch(FETCH, { model });
  }
}
