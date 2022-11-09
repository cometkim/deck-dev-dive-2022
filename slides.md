---
theme: apple-basic
layout: intro-image
image: /deck-cover.png
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
css: unocss
aspectRatio: 16/9
download: true
fonts:
  sans: 'Pretendard'
  mono: 'Hack'
---

<!--
-->

---

## 발표자 소개

<div class="flex">
  <figure class="mt-16">
    <img src="/images/speaker.jpg" width="200" class="b-rd-4"/>
    <figcaption class="mt-4 text-center">
      김혜성 <small>(Hyeseong Kim)</small>
    </figcaption>
  </figure>

  - 당근마켓 웹 프론트엔드 개발자
  - [Reason Seoul](https://twitter.com/reasonseoul) 커뮤니티 오거나이저
  - [Twitter (@KrComet)](https://twitter.com/KrComet) / [GitHub (@cometkim)](https://github.com/cometkim)
</div>

<style>
  ul {
    @apply flex flex-col justify-center p-10;

    list-style: initial;
  }
</style>

<!--
-->

---

## 커뮤니티 소개

<div class="flex">
  <figure class="mt-16">
    <img src="/images/reason-seoul.png" width="200" class="b-rd-4"/>
    <figcaption class="mt-4 text-center">
      Reason Seoul
    </figcaption>
  </figure>

  - ML-family (Reason / OCaml / ReScript)
  - 함수형 프로그래밍, 프로그래밍 언어론
  - React, GraphQL, 프론트엔드 개발
  - etc
</div>

<style>
  ul {
    @apply flex flex-col justify-center p-10;

    list-style: initial;
  }
</style>

<!--
-->

---
layout: intro
---

# TDD

## (Type-Driven Development)

---
layout: center
class: text-center
---

# 조금 낯익은 약자

**TDD** (Test-Driven) vs. **TDD** (Type-Driven)

---
layout: center
---

# 타입 주도 개발?

- **타입을 우선** 작성합니다.
- **컴파일러**에 깊게 의존합니다.
- **일부** 테스트를 대체합니다.

---
layout: center
---

# 타입 주도 개발은

- 코드를 더 **이해하기 쉽게** 만듭니다.
- 코드를 더 **안전하게** 만듭니다.
- 코드를 더 **빠르게** 만듭니다.

---
layout: center
---

<p>

어제 보니까 동적타입언어(Clojure)도 좋던데요 🤔

</p>

<style>
  p {
    font-size: 1.5rem;
  }
</style>

---
layout: center
class: text-center
---

- ✅  컴파일 타임 vs 런타임
- ❌  타입 있음 vs 타입 없음

---
layout: center
---

## 전제. 피드백은 빠를 수록 좋다

---
layout: intro
---

# 원칙 1.

## 타입을 먼저 작성합니다

---

<div grid="~ cols-2 gap-8">

```ts
const TodoId = register();

function newTodo(text);
function updateTodo(id, todo);
```

```ts{0|12-18|1-12}
type TodoId = Id<'Todo'>;
const TodoId = register<TodoId>();

type Todo = {
  id: TodoId,
  text: string,
};

type TodoPatch = {
  text?: string,
};

function newTodo(text: string): Todo;

function updateTodo(
  id: TodoId,
  todo: TodoPatch
): void;
```

</div>

---
layout: center
---

## 결과

- 👍 의도를 이해하기 쉬워졌습니다.
- 🤔 코드가 엄청 길어졌습니다.

---
layout: center
class: text-center
---

## 이런 테스트는 이제 필요 없습니다

<div class="text-left mt-8" grid="~ cols-2 gap-8">

```ts
test('Todo를 생성합니다', t => {
  const todo = newTodo('발표 자료 만들어라');
  t.expect(typeof todo.id).toBe('string');
  t.expect(typeof todo.text).toBe('string');
});
```

```ts
test('올바른 사용법', t => {
  const update = () => updateTodo(
    TodoId.of('valid'),
    {},
  );
  t.expect(update).not.toThrow();
});

test('올바르지 않은 사용법', t => {
  const update = () => updateTodo(
    'invalid',
    {},
  );
  t.expect(update).toThrowError();
});
```

</div>

---
layout: center
---

## 결과

- 👍 의도를 이해하기 쉬워졌습니다.
- ~~🤔 코드가 엄청 길어졌습니다.~~
- 💡 작성한 타입만큼 테스트를 줄였습니다.
- 🔥 더 빠른 피드백

---
layout: center
---

# 함수형 프로그래밍과 타입

<!--
-->

---
layout: center
class: text-center
---

<p>

**함수형 프로그래밍**은 프로그램을 일련의 **데이터** **변환 과정**으로 정의합니다.

</p>

```js
let program = a(b(c(...)));
```

<style>
  code {
    font-size: 1.5rem;
  }
</style>

---
layout: center
---

즉, 프로그램의 모든 부분은 타입 시스템으로 검증 가능!

- 순수 데이터 구조 (Data Structure)
- 변환 과정 (State Machine)

---
layout: center
---

## 하지만, 드러나지 않는 부분도 있습니다

```ts
// Mutable State! 전역 Todo 목록

// Side-effect! 새 Todo가 목록에 등록됨
function newTodo(text: string): Todo;

// Side-effect! Todo 목록을 순회함
// Side-effect! Todo 목록을 변경함
function updateTodo(id: TodoId, todo: TodoPatch): void;
```

---
layout: center
---

## 함수형 프로그래머 물리치는 법

- 👻 Mutable State
- 😱 Side-Effects

---
layout: center
---

## 전제. 암묵적인 것 보다 명시적인 것이 낫다

---
layout: intro
---

# 원칙 2.

## 가능한 모든 맥락을 명시적으로 선언합니다

---
layout: center
---

```ts
// ✅ Todo 목록 객체
type TodoList = {
  todos: Todo[],
};

// ✅ 새 Todo 를 목록에 추가합니다.
function newTodo(todos: TodoList, text: string): Todo;

// ✅  Todo 목록을 순회합니다.
// ✅  Todo 목록을 변경합니다.
function updateTodo(
  todos: TodoList,
  id: TodoId,
  todo: TodoPatch
): Result<Todo, Error>;
```

---
layout: center
---

### 부원칙. 불변(Immutable)객체가 더 좋습니다

```ts
// ✅ Todo 목록 객체
type TodoList = Readonly<{
  todos: ReadonlyArray<Todo>,
}>;

// ✅ 새 Todo가 추가된 새 목록을 반환합니다.
function newTodo(todos: TodoList, text: string): [TodoList, Todo];

// ✅  Todo 목록을 순회합니다.
// ✅  변경된 새 Todo 목록을 반환합니다.
function updateTodo(
  todos: TodoList,
  id: TodoId,
  todo: TodoPatch,
): Result<[TodoList, Todo], Error>;
```

---
layout: center
---

**데이터** 뿐만 아니라 **상태(State)** 도요!

---
layout: center
---

```ts
// side-effect free!
type State = {
  todoList: TodoList,
  isLoading: boolean,
};
```

<p>

근데, 로딩 중에 `newTodo()`, `updateTodo()` 호출하면 어떡하지?

</p>

---
layout: intro
---

# 원칙 3.

## 불가능한 것은 불가능하게 만듭니다

---
layout: center
---

<div grid="~ cols-2 gap-8">

```ts
// Discrimination Key = `kind`
type State = (
  | { kind: 'Loading' }
  | { kind: 'Ready', todoList: TodoList }
);

let state: State = { kind: 'Loading' }
```

```ts
// ReScript 로는 이렇게 쓸 수 있습니다!
type state =
  | Loading
  | Ready(TodoList)

let state = Loading
```

</div>

<p>

로딩 중에는 `todoList` 객체에 액세스 할 수 없습니다.

</p>

<p>

이제 컴파일러만 믿으라구 👍

</p>

---
layout: center
---

<p>

테스트도 좋지만 **불변식(_invariant_)** 은 더 좋습니다.

</p>

---
layout: center
---

### 그래서 이걸 어떻게 쓰나요?

바깥 세상(ex. DOM API)에는 여전히 _무서운 것들_ 이 있는데...

---
layout: intro
---

# 원칙 4.

## 가능한 일찍 순수한 데이터로 변환합니다

---
layout: center
---

<div grid="~ cols-2 gap-8">

```ts
/**
 * 동작을 순수한 데이터로 표현합니다.
 */
type Action = (
  | { kind: 'Init', todoList: TodoList }
);

/**
 * Action을 입력받아 다음 상태를 계산합니다.
 */
function reduce(state: State, action: Action): State {
  switch (action.kind) {
    case 'Init': {
      switch (state.kind) {
        case 'Loading': {
          return {
            kind: 'Ready',
            todoList: [...action.todoList],
          };
        }
      }
      break;
    }
    break;
  }
  invariant('Invalid match');
}
```

```js
// ReScript로 작성하면 훨씬 간결합니다!
type action =
  | Init(TodoList)

let reduce = (state, action) => switch (state, action) {
  | (Loading, Init(todoList)) => Ready(todoList)
}
```

</div>

---
layout: center
---

<div grid="~ cols-2 gap-8">

```ts{1-4|3|4}
fetch('https://todos')
  .then(res => res.json())
  .then(TodoList.fromJson)
  .then(todoList => dispatch({ kind: 'Init', todoList }))
```

```ts{0|1-4|6-11}
function parseEvent(e: Event): Action {
  const text = e.target.value;
  return { kind: 'AddTodo', text };
}

const handleSubmit = dispatch => e => {
  // Note: 가능한 일찍 호출해서
  //  시스템 지식인 Event 타입이 프로그램까지 전파되지 않도록 합니다.
  const action = parseEvent(e);
  dispatch(action);
};
```

</div>

---
layout: intro
---

# 원칙 5.

## 프로그램을 시스템으로부터 격리합니다

---
layout: center
---

![Functional Program Architecture Overview](/images/functional-program-architecture.png)

---
layout: center
---

```ts
// Note: 외부에서 주입된 환경으로 부터 프로그램을 초기화합니다.
function makeProgram(window: Window) {
  let state: State = { kind: 'Loading' };

  function dispatch(action: Action) {
    state = reduce(state, action);
  }

  return {
    init: () => fetch('https://todos')
      .then(res => res.json())
      .then(TodoList.fromJson)
      .then(todoList => dispatch({ kind: 'Init', todoList })),
    addTodo: () => { ... },
    updateTodo: () => { ... },
  };
}

const context = makeProgram(window);
```

---
layout: intro
---

# 원칙 6.

## 가능한 타입을 단순하게 유지하기

---
layout: center
---

정말 이런게 필요한가요?

```ts
type RequireOnlyOne<T, Keys extends keyof T = keyof T> =
    Pick<T, Exclude<keyof T, Keys>>
    & {
        [K in Keys]-?:
            Required<Pick<T, K>>
            & Partial<Record<Exclude<Keys, K>, undefined>>
    }[Keys]
```

---
layout: center
---

```ts{1-3|5-9}
// Pros: 보일러 플레이트 감소
// Cons: 타입레벨 복잡성
function updateUser(id: UserId, user: RequireOnlyOne<UserPatch>);

// Pros: 단순함
// Cons: 지루함
function updateUsername(id: UserId, username: string);
function updateNickname(id: UserId, nickname: string);
function updateAvatar(id: UserId, avatar: URL);
```

---
layout: center
---

![David said "Making TypeScript Happy is Full-time Job"](/images/making-typescript-happy.png)

---
layout: intro
---

# 보너스: 성능 이야기

---
layout: center
---

## Immutability

- 더 일관적인 성능을 보입니다.
- 더 최적화하기 쉽습니다.

---
layout: center
---

## Monomorphism vs. Polymorphism

---
layout: intro-image
image: /jit-opts.png
---

<!--
See https://mrale.ph/blog/2015/01/11/whats-up-with-monomorphism.html
-->

---
layout: center
---

그래서 결론은...?

---
layout: center
class: text-center
---

<figuire>

![ReScript Logo](/images/rescript-logo.png)

<figcaption>

**ReScript** 는 타입주도개발을 위한 완전 컴파일러 입니다.

</figcaption>

</figuire>

<style>
  img {
    width: 50%;
    margin: 0 auto;
  }
</style>

---
layout: center
---

# <span class="rescript">ReScript</span> 는

- 코드를 더 <span class="rescript">**이해하기 쉽게**</span>만듭니다.
- 코드를 더 <span class="rescript">**안전하게**</span> 만듭니다.
- 코드를 더 <span class="rescript">**빠르게**</span> 만듭니다.

<style>
  .rescript {
    color: #D33F3E;
  }
</style>

---
layout: center
---

## 사례: MessagePack 디코더 리팩토링

[![](/images/msgpack-pr.jpeg)](https://github.com/daangn/urlpack/pull/6)

---
layout: intro
---

# Example: 7GUIs
