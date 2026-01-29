import $ from 'jquery'
import axios from 'modules/axios'

// フォロワーの数を+1
const followersCountUp = () => {
  const followerCount = $('#followers_count').text()
  const count = Number(followerCount)
  $('#followers_count').text(count+1)
}

// フォロワーの数を-1
const followersCountDown = () => {
  const followerCount = $('#followers_count').text()
  const count = Number(followerCount)
  $('#followers_count').text(count-1)
}

// フォローする
const listenFollowEvent = (accountId) => {
  $('.follow').on('click', function() {
    axios.post(`/accounts/${accountId}/follow`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          $('.unfollow').removeClass('hidden')
          followersCountUp()
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })
}

// フォローを外す
const listenUnfollowEvent = (accountId) => {
  $('.unfollow').on('click', function() {
    axios.post(`/accounts/${accountId}/unfollow`)
      .then((res) => {
        if (res.data.status === 'ok') {
          $(this).addClass('hidden')
          $('.follow').removeClass('hidden')
          followersCountDown()
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })
}

export {
  listenFollowEvent,
  listenUnfollowEvent
}