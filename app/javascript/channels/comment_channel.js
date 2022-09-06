import consumer from "./consumer"

consumer.subscriptions.create('CommentsChannel', {
  connected() {
      this.perform('follow');
  },

  received(data) {
      if(gon.user_id !== data.user_id) {
          $('.' + data.commentable_type.toLowerCase() + '-comments' + ' .comments-' + data.commentable_id + ' ul').append('<li>' + data.comment + '</li>');
      }
  }
})