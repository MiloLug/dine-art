// defined by Main.OwnerLoader: the finalizer records where it ran in a property, which both loaders see
public class Owned {
    @Override protected void finalize() {
        System.setProperty("owned.finalized", Thread.currentThread().getThreadGroup().getName());
    }
}
