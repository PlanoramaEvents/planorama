export const tagFormatter =  (tag) => {
  if (!tag) return '';
  return tag.split(' ').map(t => t[0].toUpperCase() + t.slice(1)).join(' ');
}

// TODO actually get these from the database
export const tagsMixin = {
  computed: {
    sessionTags() {
      // TODO get these from the database
      return ['cabbages', 'kings', 'queens', 'rutabegas', 'radishes'];
    },
    sessionLabels() {
      // TODO get these from the database
      return ['needs review', 'options', 'do not reschedule', 'probable', 'really cool'];
    },
    sessionTagsOptions() {
      return this.sessionTags.map(t => ({text: tagFormatter(t), value: t}))
    },
    sessionLabelsOptions() {
      return this.sessionLabels.map(t => ({text: tagFormatter(t), value: t}))
    }
  },
  methods: {
    tagFormatter,
    formatTags(tags) {
      return tags.length ? tags.map(tagFormatter).join(", ") : 'None'
    }
  }
}
