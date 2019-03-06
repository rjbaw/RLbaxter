import torch
import torch.multiprocessing as mp

torch.set_default_tensor_type(torch.cuda.FloatTensor)

def sender(q, e):
    for i in range(10):
        s_sample = [torch.zeros(1), torch.ones(1)]
        q.put(s_sample)
        e.wait()
        del s_sample
        e.clear()

if __name__ == "__main__":
    ctx = mp.get_context("spawn")
    q = ctx.Queue()
    e = ctx.Event()
    p = ctx.Process(target=sender, args=(q, e))
    p.start()

    for i in range(10):
        print('=== ITER {} ===".format(i))
        r_sample = q.get()
        del r_sample
        e.set()

    p.join()

