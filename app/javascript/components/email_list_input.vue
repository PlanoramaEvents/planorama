<template>
  <b-overlay :show="loadingEmails" rounded="sm">
    <div class="tag-input">
      <div
        v-for="(tag, index) in valid_tags" :key="tag"
        class="badge badge-secondary p-form-tag"
      >
        {{ tag }}
        <span class='p-form-tag-remove' @click='removeValidTag(index)'>x</span>
      </div>
      <div
        v-for="(tag, index) in invalid_tags" :key="tag"
        class="badge badge-danger p-form-tag"
      >
        {{ tag }}
        <span class='p-form-tag-remove' @click='removeInvalidTag(index)'>x</span>
      </div>
      <input
        type="text"
        placeholder="Enter email(s) ..."
        class="p-form-new-tag"
        v-model="newTag"
        @keydown.enter='addTags'
        @keydown.188.stop='addTags'
        @keydown.delete.stop='removeLastTag'
      />
    </div>
  </b-overlay>
</template>

<!--
TODO: space, comma, enter etc, and paste ?
-->
<script>
import {http as axios} from '../http';

export default {
  name: 'EmailListInput',
  props: {
    value: {
      type: Array,
      default: () => []
    }
  },
  data () {
    return {
      newTag: "",
      valid_tags: this.value,
      invalid_tags: [],
      loadingEmails: false
    }
  },
  watch: {
    value(n,o) {
      this.valid_tags = n
    },
    valid_tags(n,o) {
      this.$emit('input', n)
    }
  },
  methods: {
    async addTags (event) {
      event.preventDefault();

      if (this.newTag.trim().length == 0) {
        return
      }

      let tags = this.newTag.trim().split(' ')
      if (tags.length > 0) {
        // remove spaces and commas from the tags ends
        tags = tags.map(t => t.trim().replace(/,\s*$/, ""))
        let all_tags = this.valid_tags.concat(this.invalid_tags, tags)
        this.validate(all_tags)
        this.newTag = ""
      }
    },

    removeLastTag(event) {
      if (event.target.value.length === 0) {
        if (this.invalid_tags.length > 0) {
          this.removeInvalidTag(this.invalid_tags.length - 1)
        } else {
          this.removeValidTag(this.valid_tags.length - 1)
        }
      }
    },

    removeValidTag (index) {
      this.valid_tags.splice(index, 1)
    },

    removeInvalidTag (index) {
      this.invalid_tags.splice(index, 1)
    },

    validate(tags) {
      this.loadingEmails = true
      axios.post(
        'validator/email',
        {
          "emails" : tags
        }
      ).then(
        (result) => {
          this.valid_tags = result.data.valid
          this.invalid_tags = result.data.invalid
          this.loadingEmails = false
        }
      ).catch(
        () => {
          this.loadingEmails = false
        }
      )
    }
  }
}
</script>

<style scoped>
.tag-input {
  /* height: auto !important; */
  border: 1px solid #ccc;
  overflow: hidden;
  padding-left: 4px;
  padding-top: 4px;
  cursor: text;
  text-align: left;
  -webkit-appearance: textfield;
  display: flex;
  flex-wrap: wrap;
}

.p-form-tag {
  border: 0;
  outline: none;
  margin-right: 0.25rem;
  margin-bottom: 0.2rem;
}

.p-form-new-tag {
  background: transparent;
  border: 0;
  outline: none;
  padding-left: 0;
  flex-grow: 1;
}

span.p-form-tag-remove {
  color: inherit;
  float: none;
  margin-left: 0.25rem;
  border: 0;
  background-color: transparent;
  padding: 0;
  filter: brightness(85%);
}
</style>
