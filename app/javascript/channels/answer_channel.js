import consumer from "./consumer"


if (gon.question_id) {
  consumer.subscriptions.create('AnswersChannel', {
    // Called when the subscription is ready for use on the server.
    connected() {
      this.perform("follow")
    },

    received(data) {
      const empty_answers_node = $('.no_answers')
      if ( empty_answers_node.length > 0) { empty_answers_node.remove() }

      if(gon.user_id !== data.user_id && gon.question_id == data.question_id) {
        console.log(data.body)
        $('.answers-list').append('<p>' + data.answer + '</p>');
      }
    }
  })
}

