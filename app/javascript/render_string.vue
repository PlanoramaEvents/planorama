<script>
export default {
  name: "RenderString",
  props: {
    string: {
      required: true,
      type: String,
    },
    data: {
      type: Object,
    },
  },
  render: function (h) {
    console.log(this);
    return h(
      { template: `<div>${this.string}</div>`, props: Object.keys(this.data) },
      { props: this.data }
    );
  },
};
</script>
