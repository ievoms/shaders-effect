using System.Collections.Generic;
using UnityEngine;

namespace Lab_2.Task_1
{
    public class ObjectPool : MonoBehaviour
    {
        [Tooltip("Object which is going to be pooled")]
        public GameObject pooledObject;

        [Tooltip("Initial size of the pool")]
        public int poolSize = 20;

        [Tooltip("Can the pool grow past the initial size")]
        public bool grow;

        private List<GameObject> pool;

        public GameObject GetPooledObject()
        {
            foreach (var obj in pool)
            {
                if (obj.gameObject.activeInHierarchy)
                {
                    continue;
                }

                return obj;
            }

            return grow
                ? AddObject()
                : null;
        }

        private GameObject AddObject()
        {
            var obj = Instantiate(pooledObject);
            obj.SetActive(false);

            pool.Add(obj);

            return obj;
        }

        private void Start()
        {
            pool = new List<GameObject>();
            for (var i = 0; i < poolSize; i++)
            {
                AddObject();
            }
        }
    }
}
