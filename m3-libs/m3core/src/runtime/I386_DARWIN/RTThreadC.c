/* Copyright according to COPYRIGHT-CMASS. */

/* This file implements the coroutine transfer: RTThread.Transfer */

#include <stdlib.h>
#include <setjmp.h>


RTThread__Transfer (from, to)
jmp_buf *from, *to;
{
  if (setjmp(*from) == 0) longjmp (*to, 1);
}

/* global, per-thread linked list of exception handlers */
void* ThreadF__handlerStack = 0;

#include <pthread.h>
#include <mach/mach.h>
#include <mach/thread_act.h>

int
RTMachine__SuspendThread (pthread_t t)
{
  mach_port_t mach_thread = pthread_mach_thread_np(t);
  if (thread_suspend(mach_thread) != KERN_SUCCESS) abort();
  return thread_abort_safely(mach_thread) == KERN_SUCCESS;
}

void
RTMachine__GetState (pthread_t t, void **sp, i386_thread_state_t *state)
{
  mach_port_t mach_thread = pthread_mach_thread_np(t);
  mach_msg_type_number_t thread_state_count = i386_THREAD_STATE_COUNT;
  if (thread_get_state(mach_thread, i386_THREAD_STATE,
		       (thread_state_t)state, &thread_state_count)
      != KERN_SUCCESS) abort();
  if (thread_state_count != i386_THREAD_STATE_COUNT) abort();
  *sp = (void *)(state->esp);
}

void
RTMachine__RestartThread (pthread_t t)
{
  mach_port_t mach_thread = pthread_mach_thread_np(t);
  if (thread_resume(mach_thread) != KERN_SUCCESS) abort();
}
