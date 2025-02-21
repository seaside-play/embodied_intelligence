#ifndef NK_LIST_HEAD_H_
#define NK_LIST_HEAD_H_

struct ListNode {
    int val;
    struct ListNode *next;
    ListNode(int x) : val(x), next(nullptr) {}
};

#endif // NK_LIST_HEAD_H_