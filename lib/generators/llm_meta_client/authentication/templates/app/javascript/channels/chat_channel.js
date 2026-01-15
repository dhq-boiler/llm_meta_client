import consumer from "channels/consumer"

// チャットチャンネルを管理するグローバルオブジェクト
window.chatSubscription = null

function subscribeToChatChannel(chatId) {
  // 既存のサブスクリプションがあればアンサブスクライブ
  if (window.chatSubscription) {
    window.chatSubscription.unsubscribe()
  }

  if (!chatId) {
    return
  }

  window.chatSubscription = consumer.subscriptions.create(
    { channel: "ChatChannel", chat_id: chatId },
    {
      connected() {
        console.log("Connected to ChatChannel:", chatId)
      },

      disconnected() {
        console.log("Disconnected from ChatChannel")
      },

      received(data) {
        console.log("Received data from ChatChannel:", data)

        if (data.action === "new_message") {
          // メッセージリストを更新
          const messagesList = document.getElementById("messages-list")
          if (messagesList && data.html) {
            messagesList.innerHTML = data.html

            // メッセージを最下部にスクロール
            const chatMessages = document.getElementById("chat-messages")
            if (chatMessages) {
              chatMessages.scrollTop = chatMessages.scrollHeight
            }
          }
        }
      }
    }
  )
}

// グローバルに公開
window.subscribeToChatChannel = subscribeToChatChannel

// チャットIDをチェックして接続
function checkAndSubscribe() {
  const chatContainer = document.querySelector(".chat-container")
  if (chatContainer) {
    const chatId = chatContainer.dataset.chatId
    if (chatId) {
      subscribeToChatChannel(chatId)
    }
  }
}

// ページロード時にチャットIDがあれば接続
document.addEventListener("DOMContentLoaded", checkAndSubscribe)

// Turbo訪問時にも対応
document.addEventListener("turbo:load", checkAndSubscribe)

// Turbo Streamsで画面が更新された後にもチェック
document.addEventListener("turbo:frame-load", checkAndSubscribe)

// MutationObserverを使ってdata-chat-idの変更を監視
const observer = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    if (mutation.type === "attributes" && mutation.attributeName === "data-chat-id") {
      checkAndSubscribe()
    }
  })
})

// DOMContentLoadedの後にobserverを設定
document.addEventListener("DOMContentLoaded", () => {
  const chatContainer = document.querySelector(".chat-container")
  if (chatContainer) {
    observer.observe(chatContainer, {
      attributes: true,
      attributeFilter: ["data-chat-id"]
    })
  }
})

