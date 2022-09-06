import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  // Called when the subscription is ready for use on the server.
  connected() {
    this.perform("follow")
  },

  received(data) {
    const empty_questions_node = $('.no_questions')
    if ( empty_questions_node.length > 0) { empty_questions_node.remove() }

    var questionsList = $('.questions-list');

    questionsList.append(data)
  }
})
